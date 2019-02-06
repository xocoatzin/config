# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import logging
import time
import os

import requests

from grpc import StatusCode
from google.protobuf.json_format import MessageToDict
from google.protobuf.timestamp_pb2 import Timestamp
from google.cloud import datastore
from google.auth import crypt
from google.auth import jwt

import UsersAPI.api_pb2 as pb2


__all__ = [
    'TokensMixin',
]

log = logging.getLogger(__name__)


class TokensMixin(object):
    """Implements the Users API server."""

    def CreateToken(self, request, context):  # noqa
        """Get a list of views for the collection."""
        request = MessageToDict(request)
        metadata = {
            meta.key.lower(): meta.value
            for meta in context.invocation_metadata()
        }

        user_id_token = metadata.get('authorization')

        if not user_id_token:
            context.abort(
                StatusCode.INVALID_ARGUMENT, "Missing argument: token")

        token_parts = user_id_token.split()
        if not len(token_parts) == 2:
            context.abort(
                StatusCode.INVALID_ARGUMENT, "Invalid token")

        user_id_token = token_parts[1]

        r = requests.get(
            'https://www.googleapis.com/oauth2/v3/tokeninfo',
            params={'id_token': user_id_token}
        )

        idinfo = {}
        try:
            if r.status_code not in [200]:
                raise ValueError('Invalid token.')

            idinfo = r.json()

            # if idinfo['aud'] not in allowed_client_ids:
            #     raise ValueError('Wrong issuer.')

            if idinfo['iss'] not in [
                    'accounts.google.com',
                    'https://accounts.google.com']:
                raise ValueError('Wrong issuer.')

            if idinfo['hd'] != 'magicleap.com':
                raise ValueError('Wrong hosted domain.')

        except ValueError as e:
            logging.info('{}: {}'.format(str(e), idinfo))
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid token.")

        user_key = self.dsclient.key('User', idinfo.get('email'))
        user_entity = self.dsclient.get(user_key)

        if user_entity:
            if user_entity.get('disabled', False):
                logging.info(
                    'User account disabled: {}'.format(idinfo))
                context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized.")

            now = datetime.datetime.utcnow()
            user_entity.update({
                'last_seen': now,
            })
            self.dsclient.put(user_entity)
            log.info("Updated user: {}".format(idinfo.get('email')))

        else:
            now = datetime.datetime.utcnow()
            user_entity = datastore.Entity(key=user_key)
            user_entity.update({
                'created_at': now,
                'last_seen': now,
                'sub': idinfo.get('sub'),
                'locale': idinfo.get('locale'),
                'picture': idinfo.get('picture'),
                'given_name': idinfo.get('given_name'),
                'family_name': idinfo.get('family_name'),
                'full_name': idinfo.get('name'),
                'email': idinfo.get('email'),
                'disabled': False,
            })
            self.dsclient.put(user_entity)
            log.info("Registered user: {}".format(idinfo.get('email')))

        user_key = self.dsclient.key('User', idinfo.get('email'))
        query = self.dsclient.query(kind='UserRole', ancestor=user_key)
        query.keys_only()

        roles = [
            entity.key.name
            for entity in query.fetch()
        ]

        query = self.dsclient.query(kind='Membership')
        query.keys_only()
        query.add_filter('user_key', '=', user_key)
        groups = [
            item.key.parent.name
            for item in query.fetch()
        ]

        now = int(time.time())
        payload = {
            # Issued at
            'iat': now,
            # Expiration, same as original ID token
            'exp': int(idinfo.get('exp')),
            # Issuer
            'iss': 'https://users.datasets.magicleap.com',
            # Audience
            'aud': 'https://datasets.magicleap.com',
            # User information
            'sub': idinfo.get('sub'),
            'email': idinfo.get('email'),
            'locale': idinfo.get('locale'),
            'picture': idinfo.get('picture'),
            'given_name': idinfo.get('given_name'),
            'family_name': idinfo.get('family_name'),
            'full_name': idinfo.get('name'),
            # Roles and groups registered in the Users API
            'roles': roles,
            'groups': groups,
        }

        signer = crypt.RSASigner.from_service_account_file(
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'])
        encoded_token = jwt.encode(signer, payload).decode('UTF-8')

        expiration_time = Timestamp()
        expiration_time.FromDatetime(
            datetime.datetime.utcfromtimestamp(int(idinfo.get('exp'))))

        return pb2.Token(
            token=encoded_token,
            type=pb2.Token.DATASETS_TOKEN,
            expiration_time=expiration_time,
        )
