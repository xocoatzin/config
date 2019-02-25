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

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize


__all__ = [
    'TokensMixin',
]


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
        """Get a list of views for the collection."""
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

        query = self.dsclient.query(kind='Membership')
        query.keys_only()
        query.add_filter('user_key', '=', user_key)
        groups = [
            item.key.parent.name
            for item in query.fetch()
        ]

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
        """Get a list of views for the collection."""
        request = MessageToDict(request)

        token = request.get('token', {}).get('datasetsToken')

        if not token:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Missing argument: datasets_token")

        # TODO: Download from:
        # https://www.googleapis.com/service_accounts/v1/metadata/x509/datasets-users-api@analyticsframework.iam.gserviceaccount.com

        public_certs = {
            "e5cb61d228893c0f8602929f3050b153f4b3b5ea": "-----BEGIN CERTIFICATE-----\nMIIDSjCCAjKgAwIBAgIIAZVDs7WMTVYwDQYJKoZIhvcNAQEFBQAwSDFGMEQGA1UE\nAxM9ZGF0YXNldHMtdXNlcnMtYXBpLmFuYWx5dGljc2ZyYW1ld29yay5pYW0uZ3Nl\ncnZpY2VhY2NvdW50LmNvbTAeFw0xOTAyMTIxMjQ3MzNaFw0xOTAzMDEwMTAyMzNa\nMEgxRjBEBgNVBAMTPWRhdGFzZXRzLXVzZXJzLWFwaS5hbmFseXRpY3NmcmFtZXdv\ncmsuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB\nDwAwggEKAoIBAQDI0DxKjkTjiVk911ryiLyO4+bPFJ5WEyDxIcgluZSZ7ncFNpOU\n0AWee/4w2iPUALKUp+W2Qnfd6SCbwjNB82Jqb8yOtgegDq8bswE6s4k5TkMVGSOU\nCCNlPT7tAoxBJtWLggdP/OietfJA5/7Tr6rjE0zQESqi/nplhgxtlbvO1s8/ui8T\n8GAtUoeZZVgzbkGKEa3dvoJvgobktph4ja7VlElRPyONn+yQG+iR5CJqNmuE6Q0s\nRIWfbNu6n6yG+xMfHim7T0C0oJP25WatKj/lKUAyFPvHyYcvPp3/qsvClQHYh05F\nufbduA02+2Xf7IUx+6hqSwaiYpONZSTNdsrjAgMBAAGjODA2MAwGA1UdEwEB/wQC\nMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMCMA0GCSqG\nSIb3DQEBBQUAA4IBAQC+IKsArY8P+dFHecqmktJhxujnBIG44cdunILXK2Rsxm8k\nzF7Zu1sX4NpH2OYFnIogV0vhbl/1r1n/EQp1b9bqA8zPBi3gvQlp/RHE499qWxT2\nTRCCwvzopvbcYWXXaxmfaS7JWPJ6WPOyp1KRugyl6kv0kAH8UMxiAcwVBvY6S90Y\ntWZDSsceQpOJZU6lsANEkMQVVS9V7nummp11RoyAeUKjazVU7DvSyhne6NrVeRKm\nBv2UKpMoziPuPsueGkGvJ1azWkg4RzrVtOefzrIBwS6qg/BItz5XPnB67V8ZI3rG\ngsG+m3kLYrUTM4ZqSzczeYJnxWR6Zj2Ix7jb5OJq\n-----END CERTIFICATE-----\n",  # noqa
            "1e0201214e90847476850e43e5800b428e58a9f0": "-----BEGIN CERTIFICATE-----\nMIIC+jCCAeKgAwIBAgIIRppiyDdYAPwwDQYJKoZIhvcNAQEFBQAwIDEeMBwGA1UE\nAxMVMTA4MTY0Mjk5OTQ4NzQwNjY2OTI0MB4XDTE5MDIwNDEzMDM0NloXDTI5MDIw\nMTEzMDM0NlowIDEeMBwGA1UEAxMVMTA4MTY0Mjk5OTQ4NzQwNjY2OTI0MIIBIjAN\nBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqgO1iMLPRSVO/Y5I9L6sdKNjrhbC\n54o9ZaOC5jUZw1V0JHD71wJYxMe44aAKT9cOYlmXcmwWEiylbWX/6TRQHh1lFI+I\nDrPT3m92noMWabZnlNvCTDFOe/RsEz/6V+9gtyvtWXeUbWSrmmu/Zv106HDWDawq\n+dOTL6ynIRX+GWsRQftXY0vbiYwWhM8JAHcaRi7e/CC/ta1HW02aB0reSX23l0qG\nP2dtAHAJEOD+pOBhdGuJPGI3W5WxWdwpUfVvuzdykcFIU822HIwV6/Q7Lp54RPym\n4JazovCkraQTJwpWqaU44yC4HbnU2KcDR6lMfuOVMSOAoBC9SzV57hzxVQIDAQAB\nozgwNjAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUBAf8EDDAK\nBggrBgEFBQcDAjANBgkqhkiG9w0BAQUFAAOCAQEAdlMObSWd+vlvvBT6ucvlPN8U\nHSFt9PGlj2d8D7pY06Q8UM3zogsv85m8ST0bBSjsUAH0dKkI1svfvx9WsC2/N0iV\nNmT7sFc+ZKWNs8IXe0XNCn5krEGd8TVQuYp7Xwz/VxatiBRn3FbrhdShgLK7rnHW\nT4i9VUbGsm1hzQWrlfaXSSFmttgrB8tUY4pgt0m0hV9jrJivI/j7FuBwnrmoEk55\nPzosm5+ML/koDsKluyYmK4s/KFniMVsazSQqjs15m363OZxXjJhMH+kH68Ria+NY\nSuH3CT2uIrPWxMI61EGsTMhICQq1vy7RYH+0Z3lVPIl4hzXrybKKVCOxnYgilw==\n-----END CERTIFICATE-----\n",  # noqa
            "80407c0b46aba6ec27e252a42f7c4457864f7712": "-----BEGIN CERTIFICATE-----\nMIIDSjCCAjKgAwIBAgIIT3sSbxKkNf4wDQYJKoZIhvcNAQEFBQAwSDFGMEQGA1UE\nAxM9ZGF0YXNldHMtdXNlcnMtYXBpLmFuYWx5dGljc2ZyYW1ld29yay5pYW0uZ3Nl\ncnZpY2VhY2NvdW50LmNvbTAeFw0xOTAyMjAxMjU2MjBaFw0xOTAzMDkwMTExMjBa\nMEgxRjBEBgNVBAMTPWRhdGFzZXRzLXVzZXJzLWFwaS5hbmFseXRpY3NmcmFtZXdv\ncmsuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB\nDwAwggEKAoIBAQC2T2vPBaS/epQHD9S2Qt1b23lzOXYzhMDj6uL1nKnePRpqHNR7\nPrLB45f+7fzNPbt0T0fYW0Q4mzdUsIUPT8WIF6o4LcxNRCdLtJrjtkzoAp8seKy+\nVh1g6klmqy0K3gKrRgJu6tfyFtZ3fa1wiT3O3g+0KxFiZTbWwDYj4Fjcle1dH/aM\nJkHKYaSTIjXZTFaaY/1xN/4sM0GjTHw2r3eShp0tmzXhIGi6tImUddaz+2s9EqHq\niYOX8pqrx7aevlSxP/XwuzAlepZHLI3gZF/YaUdtKhQ2XBcbUG4nhUs7H4FQ2AJZ\nqUld6IHJMDR0blZan/G6xVKrXQbIWD9GdYO5AgMBAAGjODA2MAwGA1UdEwEB/wQC\nMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMCMA0GCSqG\nSIb3DQEBBQUAA4IBAQAxRqZFD+lCCPqadmdck8c1tAk7QfKNF0aiiZl7/Auvm7UH\nsshvnhJe1tME7kZqa7rbDPg7AUUoXRyZhwgaeHtFqy8Ydm2VO+xyMQgVJD4/qlW+\nXDmXPALFG1ieRirSrCAh8w3SJptjcMCcBhAKxpFWGkmXK5gBm8sR3aKkGcgzkodv\nXn8qitEz/sB60yg5lK3i1A7SCvtdlo0W5XFfN2oJeMpnDtmK4mqCqDNJRegI2a7y\niLb7PAgJGYQGbCJ6n6huxUcxZbCqF1d9TykAf0a7H3C4TDTX4/jzsBj1RZSZ6MVU\njb37Xw3AQKkvbsQ6Le1BMKGZSiM6E2zSnnAHMu1Y\n-----END CERTIFICATE-----\n"  # noqa
        }

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
