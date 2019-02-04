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
# from google.protobuf import struct_pb2
from google.protobuf.json_format import MessageToDict
from google.protobuf.timestamp_pb2 import Timestamp
from google.cloud import datastore
from google.auth import crypt
from google.auth import jwt

import UsersAPI.api_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


__all__ = [
    'TokensMixin',
]

log = logging.getLogger(__name__)


# allowed_client_ids = [
#     '439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.googleusercontent.com', # CLI  # noqa
#     '763597474440-jitt7oqo7jppgg497dq4ae9uq5japai5.apps.googleusercontent.com', # datasets-frontend # noqa
#     '439260306570-1hs8vdfr2p5pkffuml6rtbbm503dsphc.apps.googleusercontent.com', # Web UI  # noqa
#     '141530362265-ucisfckjpadkc4v002ibkc5aeacaqstv.apps.googleusercontent.com', # eguendelman's # noqa
#     '107918144537744202871', # analyticsframework@appspot.gserviceaccount.com --> default  # noqa
#     '103311373514881609732', # batch-runner@analyticsframework.iam.gserviceaccount.com  # noqa
#     '115896839819721072399', # head-pose-batch-eval@analyticsframework.iam.gserviceaccount.com  # noqa
#     '110050846120109587941', # gaze-batch-eval@analyticsframework.iam.gserviceaccount.com  # noqa
#     '111014016425078685290', # sipp-extractor@analyticsframework.iam.gserviceaccount.com  # noqa
#     '116369930344624784826', # worker-sensor-ramon-sensim@analyticsframework.iam.gserviceaccount.com  # noqa
#     '104377765709731293974', # datasets-development-environme@analyticsframework.iam.gserviceaccount.com  # noqa
# ]


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
                'roles': [],
                'groups': [],
                'disabled': False,
            })
            self.dsclient.put(user_entity)
            log.info("Registered user: {}".format(idinfo.get('email')))

        now = int(time.time())
        payload = {
            # Issued at
            'iat': now,
            # Expiration, same as original ID token
            'exp': idinfo.get('exp'),
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
            'roles': user_entity.get('roles', []),
            'groups': user_entity.get('groups', []),
            'some': 'payload',
        }

        signer = crypt.RSASigner.from_service_account_file(
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'])
        encoded_token = jwt.encode(signer, payload)

        expiration_time = Timestamp()
        expiration_time.FromDatetime(
            datetime.datetime.utcfromtimestamp(int(idinfo.get('exp'))))
        return pb2.Token(
            token=encoded_token,
            type=pb2.Token.DATASETS_TOKEN,
            expiration_time=expiration_time,
        )
