# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import os
import time

import requests

from grpc import StatusCode
from google.protobuf.json_format import MessageToDict
from google.protobuf.timestamp_pb2 import Timestamp
from google.cloud import datastore
from google.auth import crypt
from google.auth import jwt
from google.oauth2 import service_account
import google.auth.transport.requests

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize


__all__ = [
    'TokensMixin',
]


def load_google_groups(domain, user):
    """Load google groups from directory API.

    Args:
        domain (str): The domain to query.
        user (str): Return the groups that the user is member of.
    """
    credentials = service_account.Credentials.from_service_account_file(
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'],
        scopes=[
            'https://www.googleapis.com/auth/admin.directory.group.readonly'
        ]
    ).with_subject(os.environ.get(
        'API_GSUITE_AUTH_SUBJECT', 'svc_srce_admin@magicleap.com'))
    credentials.refresh(google.auth.transport.requests.Request())

    # Load all the pages
    groups_found = []

    next_page_token = None
    params = {
        'domain': domain,
        'userKey': user,
    }
    while True:
        if next_page_token:
            params['pageToken'] = next_page_token

        response = requests.get(
            'https://www.googleapis.com/admin/directory/v1/groups',
            params=params,
            headers={
                'Authorization': 'Bearer {}'.format(credentials.token)
            }
        )
        response_data = response.json()

        # Load groups and aliases from response.
        for group in response_data.get('groups', []):
            groups_found.append(group.get('email'))
            groups_found += group.get('aliases', [])

        next_page_token = response_data.get('nextPageToken')
        if next_page_token is None:
            break

    return groups_found


# Access token:
# {
#     "azp": "439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.
#         googleusercontent.com",
#     "aud": "439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.
#         googleusercontent.com",
#     "sub": "116239921441103745586",
#     "exp": "1549888861",
#     "email": "atorresgomez@magicleap.com",
#     "email_verified": "true",

#     "scope": "https://www.googleapis.com/auth/userinfo.email
#         https://www.googleapis.com/auth/userinfo.profile
#         https://www.googleapis.com/auth/devstorage.read_write",
#     "expires_in": "3542",
#     "access_type": "offline"
# }

# ID Token:
# {
#     "azp": "439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.
#         googleusercontent.com",
#     "aud": "439260306570-b8ehja938h32vbl9jb6s2ml4tl8pk9s2.apps.
#         googleusercontent.com",
#     "sub": "116239921441103745586",
#     "exp": "1549888861",
#     "email": "atorresgomez@magicleap.com",
#     "email_verified": "true",

#     "iss": "https://accounts.google.com",
#     "hd": "magicleap.com",
#     "at_hash": "qNC2ht4Eq-OHgdw65dlnEw",
#     "name": "Alan Torres",
#     "picture": "https://lh4.googleusercontent.com/-E0jiKQgPthY/
#         AAAAAAAAAAI/AAAAAAAAAVY/aQZN1tGuhpI/s96-c/photo.jpg",
#     "given_name": "Alan",
#     "family_name": "Torres",
#     "locale": "en",
#     "iat": "1549885261",
#     "alg": "RS256",
#     "kid": "7c309e3a1c1999cb0404ab7125ee40b7cdbcaf7d",
#     "typ": "JWT"
# }


class TokensMixin(object):
    """Implements the Users API server."""

    @authorize(requires=[])  # Intentionally left empty
    def CreateToken(self, request, context, options):  # noqa
        """Create a Datasets Token from an access or ID token."""
        request = MessageToDict(request)

        token_type = 'access_token'
        token = request.get('token', {}).get('accessToken')
        if not token:
            token_type = 'id_token'
            token = request.get('token', {}).get('idToken')

        if not token:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Missing argument: access_token or id_token")

        if not token_type:
            parts = token.split('.')
            if len(parts) == 2:
                token_type = 'access_token'
            elif len(parts) == 3:
                token_type = 'id_token'

        if token_type not in ['access_token', 'id_token']:
            context.abort(
                StatusCode.INVALID_ARGUMENT, "Invalid token type")

        req = requests.get(
            'https://www.googleapis.com/oauth2/v3/tokeninfo',
            params={token_type: token}
        )

        if req.status_code not in [200]:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid token.")

        # If true, the user can register their own user account
        can_self_register = False
        now = datetime.datetime.utcnow()
        user_info = {
            'last_seen': now
        }

        # ID tokens contain the user profile information, we can use this to
        # update the user account, or create it if it doesn't exist
        if token_type == 'id_token':
            token_info = req.json()

            if token_info['iss'] not in [
                    'accounts.google.com',
                    'https://accounts.google.com']:
                context.abort(StatusCode.INVALID_ARGUMENT, "Wrong issuer.")

            if token_info['hd'] in ['magicleap.com']:
                can_self_register = True

            user_info['sub'] = token_info.get('sub')
            user_info['email'] = token_info.get('email')
            user_info['full_name'] = token_info.get('name')
            user_info['picture'] = token_info.get('picture')
            user_info['locale'] = token_info.get('locale')
            user_info['given_name'] = token_info.get('given_name')
            user_info['family_name'] = token_info.get('family_name')

        # If this is an access token, we will need to request the user profile
        # information. If we can get it and verify the user's hosted domain
        # claim, we can then create the account. Otherwise the account needs
        # to be created manually
        elif token_type == 'access_token':
            token_info = req.json()
            scope = 'https://www.googleapis.com/auth/userinfo.profile'

            if scope not in token_info.get('scope', ''):
                context.abort(
                    StatusCode.INVALID_ARGUMENT,
                    "Scope missing in access token: {}.".format(scope))

            req = requests.get(
                'https://www.googleapis.com/oauth2/v3/userinfo',
                params={'access_token': token}
            )

            if req.status_code not in [200]:
                context.abort(
                    StatusCode.INVALID_ARGUMENT,
                    "Could not verify user's profile.")

            profile_info = req.json()

            if profile_info.get('hd') in ['magicleap.com']:
                can_self_register = True

            # User and service accounts
            user_info['sub'] = profile_info.get('sub')
            user_info['email'] = profile_info.get('email')
            user_info['full_name'] = profile_info.get('name')
            user_info['picture'] = profile_info.get('picture')
            user_info['locale'] = profile_info.get('locale')

            # User accounts only
            user_info['given_name'] = profile_info.get('given_name')
            user_info['family_name'] = profile_info.get('family_name')

        # TODO
        #     # if idinfo['aud'] not in allowed_client_ids:
        #     #     raise ValueError('Wrong issuer.')

        user_key = self.dsclient.key('User', user_info.get('email'))
        user_entity = self.dsclient.get(user_key)

        # The user was found
        if user_entity:
            if user_entity.get('disabled', False):
                options.log.info(
                    'User account disabled: {}'.format(user_info))
                context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized.")

            user_entity.update(user_info)
            self.dsclient.put(user_entity)
            options.log.info("Updated user: {}".format(user_info.get('email')))

        else:
            if can_self_register:
                user_entity = datastore.Entity(key=user_key)
                user_info['created_at'] = now
                user_info['disabled'] = False
                user_entity.update(user_info)
                self.dsclient.put(user_entity)
                options.log.info(
                    "Registered user: {}".format(user_info.get('email')))
            else:
                context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized.")

        query = self.dsclient.query(kind='UserRole', ancestor=user_key)
        query.keys_only()

        roles = [
            entity.key.name
            for entity in query.fetch()
        ]

        # query = self.dsclient.query(kind='Membership')
        # query.keys_only()
        # query.add_filter('user_key', '=', user_key)
        # groups = [
        #     item.key.parent.name
        #     for item in query.fetch()
        # ]

        ml_groups = []
        try:
            options.log.info("Loading Google Groups")
            ml_groups = load_google_groups(
                'magicleap.com', user_info.get('email'))
        except Exception as e:
            options.log.exception(
                "Error loading Google Groups: {}".format(str(e)))

        groups = {
            '@magicleap.com': [
                g.split('@')[0]  # remove the domain
                for g in ml_groups
            ]
        }

        now = int(time.time())
        expiration = int(token_info.get('exp'))
        payload = {
            # Issued at
            'iat': now,
            # Expiration, same as original ID token
            'exp': expiration,
            # Issuer
            'iss': 'https://users.datasets.magicleap.com',
            # Audience
            'aud': 'https://datasets.magicleap.com',
            # User information
            'sub': user_info.get('sub'),
            'email': user_info.get('email'),
            'locale': user_info.get('locale'),
            'picture': user_info.get('picture'),
            'given_name': user_info.get('given_name'),
            'family_name': user_info.get('family_name'),
            'full_name': user_info.get('full_name'),
            # Roles and groups registered in the Users API
            'roles': roles,
            'groups': groups,
        }

        signer = crypt.RSASigner.from_service_account_file(
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'])
        encoded_token = jwt.encode(signer, payload).decode('UTF-8')

        expiration_time = Timestamp()
        expiration_time.FromDatetime(
            datetime.datetime.utcfromtimestamp(expiration))

        return pb2.Token(
            datasets_token=encoded_token,
            expiration_time=expiration_time,
        )

    @authorize(requires=[])  # Intentionally left empty
    def GetTokenInfo(self, request, context, options):  # noqa
        """Validate and get the information about the token."""
        request = MessageToDict(request)

        token = request.get('token', {}).get('datasetsToken')

        if not token:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Missing argument: datasets_token")

        # TODO: Load email from config
        service_account_email = \
            'datasets-users-api@analyticsframework.iam.gserviceaccount.com'
        response = requests.get((
            'https://www.googleapis.com/service_accounts/v1/metadata/x509/{}'
        ).format(service_account_email))
        public_certs = response.json()

        try:
            token_info = jwt.decode(token, certs=public_certs)
        except Exception as e:
            options.log.exception(str(e))
            context.abort(StatusCode.PERMISSION_DENIED, "Invalid token.")

        return pb2.TokenInfo(
            iat=token_info.get('iat'),
            exp=token_info.get('exp'),
            iss=token_info.get('iss'),
            aud=token_info.get('aud'),
            sub=token_info.get('sub'),
            email=token_info.get('email'),
            locale=token_info.get('locale'),
            picture=token_info.get('picture'),
            given_name=token_info.get('given_name'),
            family_name=token_info.get('family_name'),
            full_name=token_info.get('full_name'),
            roles=token_info.get('roles'),
            groups=token_info.get('groups'),
        )
