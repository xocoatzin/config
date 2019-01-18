# -*- coding: utf-8 -*-
"""Datasets Users API.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import base64
import json
import logging
import time

from google.appengine.api import app_identity
from google.appengine.api import urlfetch

import endpoints
from endpoints import remote
from endpoints import message_types  # noqa
from endpoints import messages
from endpoints import (  # noqa
    BadRequestException, UnauthorizedException,
    ForbiddenException, NotFoundException,
    InternalServerErrorException
)

from models import KNOWN_ROLES, _User


class JwtRequest(messages.Message):
    """Request for a Datasets Token.

    Attributes:
        id_token (str): User's ID token issued by Google.
    """

    id_token = messages.StringField(1, required=True)


class JwtReply(messages.Message):
    """Reply from Datasets.

    Attributes:
        token (str): A JWT token signed by Datasets, used to authorize user's
            access to Datasets projects.
        expires (int): A unix timestamp indicating when the token expires.
    """

    token = messages.StringField(1, required=True)
    expires = messages.IntegerField(2, required=True)

# WIP
allowed_client_ids = [
    '439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.googleusercontent.com', # CLI  # noqa
    '763597474440-jitt7oqo7jppgg497dq4ae9uq5japai5.apps.googleusercontent.com', # datasets-frontend # noqa
    '439260306570-1hs8vdfr2p5pkffuml6rtbbm503dsphc.apps.googleusercontent.com', # Web UI  # noqa
    '141530362265-ucisfckjpadkc4v002ibkc5aeacaqstv.apps.googleusercontent.com', # eguendelman's # noqa
    '107918144537744202871', # analyticsframework@appspot.gserviceaccount.com --> default  # noqa
    '103311373514881609732', # batch-runner@analyticsframework.iam.gserviceaccount.com  # noqa
    '115896839819721072399', # head-pose-batch-eval@analyticsframework.iam.gserviceaccount.com  # noqa
    '110050846120109587941', # gaze-batch-eval@analyticsframework.iam.gserviceaccount.com  # noqa
    '111014016425078685290', # sipp-extractor@analyticsframework.iam.gserviceaccount.com  # noqa
    '116369930344624784826', # worker-sensor-ramon-sensim@analyticsframework.iam.gserviceaccount.com  # noqa
    '104377765709731293974', # datasets-development-environme@analyticsframework.iam.gserviceaccount.com  # noqa
]


@endpoints.api(
    name='users',
    version='v1',

    canonical_name='Datasets Users API',
    title='Datasets Users API',
    description='Datasets Users API',
    documentation='',
    hostname='users.analyticsframework.appspot.com',
    owner_domain='magicleap.com',
    owner_name='Magic Leap Inc.',
    scopes=[
        'https://www.googleapis.com/auth/userinfo.email',
    ],
    allowed_client_ids=allowed_client_ids,
    api_key_required=True,
)
class UsersApi(remote.Service):
    """Users API service class."""

    @endpoints.method(
        JwtRequest,
        JwtReply,
        path='auth/getDatasetsToken',
        http_method='POST',
        name='auth.getDatasetsToken')
    def get_datasets_token(self, request):
        """Exchange a Google ID token for a Datasets Token."""
        # Verify that the ID token is valid
        idinfo = {}
        try:
            result = urlfetch.fetch((
                "https://www.googleapis.com"
                "/oauth2/v3/tokeninfo?id_token={}").format(request.id_token))

            if result.status_code not in [200]:
                raise ValueError(result.content)

            idinfo = json.loads(result.content)

            if idinfo['aud'] not in allowed_client_ids:
                raise ValueError('Wrong issuer.')

            if idinfo['iss'] not in [
                    'accounts.google.com',
                    'https://accounts.google.com']:
                raise ValueError('Wrong issuer.')

            if idinfo['hd'] != 'magicleap.com':
                raise ValueError('Wrong hosted domain.')

        except ValueError as e:
            logging.info('{}: {}'.format(str(e), idinfo))
            raise UnauthorizedException('Unauthorized.')

        # Load the user from DB.
        user = _User.get_by_id(idinfo.get('sub'))
        if not user or user.disabled:
            logging.info(
                'User not found or account disabled: {}'.format(idinfo))
            raise UnauthorizedException('Unauthorized.')

        # The ID token has been validated, we generate a JWT for the user...
        header_json = json.dumps({
            "typ": "JWT",
            "alg": "RS256"})

        now = int(time.time())
        expires = now + 3600
        payload_json = json.dumps({
            # Issued at and expiration (60 min)
            'iat': now,
            'exp': expires,

            # Issuer: The default Service Acct.
            'iss': 'https://users.datasets.magicleap.com',
            # 'iss': 'analyticsframework@appspot.gserviceaccount.com',

            # Audience
            'aud': 'https://datasets.magicleap.com',

            # Sub = User ID
            'sub': idinfo.get('sub'),
            'email': idinfo.get('email'),

            # Roles and groups registered in the Users API
            'roles': [
                role
                for role in user.roles
                if role in KNOWN_ROLES
            ],
            'groups': [
                group.id()
                for group in user.groups
            ]
        })

        # Sign and encode the JWT using the default Service Account.
        header_and_payload = '{}.{}'.format(
            base64.urlsafe_b64encode(header_json),
            base64.urlsafe_b64encode(payload_json))
        (key_name, signature) = app_identity.sign_blob(header_and_payload)
        signed_jwt = '{}.{}'.format(
            header_and_payload,
            base64.urlsafe_b64encode(signature))

        return JwtReply(token=signed_jwt, expires=expires)

api = endpoints.api_server([UsersApi])
