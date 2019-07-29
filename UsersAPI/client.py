# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

# Ignore this file: WIP

# import arrow
import argparse
import random
import json
import os

from google.protobuf import empty_pb2
from google.protobuf import field_mask_pb2
from google.protobuf.json_format import MessageToDict
import grpc

from UsersAPI.lib.magicleap.datasets import users_pb2 as pb2
from UsersAPI.lib.magicleap.datasets import users_pb2_grpc

# from google.protobuf.timestamp_pb2 import Timestamp

# python metrics-server/client.py --host 127.0.0.1 --port 18000 --api_key AIzaSyAgwZX25V5FZjgu_DHWmdHi5GxQZkqyjMw

# flake8: noqa

class Client(object):

    def __init__(self, host, port, api_key, auth_token):
        channel = grpc.insecure_channel('{}:{}'.format(host, port))

        self.tstub = users_pb2_grpc.TokensStub(channel)
        self.stub = users_pb2_grpc.UsersStub(channel)
        self.metadata = []
        if api_key:
            self.metadata.append(('x-api-key', api_key))
        if auth_token:
            self.metadata.append(('authorization', 'Bearer ' + auth_token))

        self._user = os.environ.get('U_EMAIL', 'me@magicleap.com')
        self._dtoken = os.environ.get('U_DSTOKEN', '...')

    def run(self, method, timeout=30):
        method_spec = getattr(self, method, None)
        if not method_spec or not callable(method_spec):
            raise Exception("Invalid method")
        method, req = method_spec()

        print('>>>\n' + json.dumps(MessageToDict(req), indent=4, sort_keys=True))
        ans = method(req, timeout, metadata=self.metadata)
        print('<<<\n' + json.dumps(MessageToDict(ans), indent=4, sort_keys=True))

    # Tokens
    def GetTokenInfo(self):
        req = pb2.TokenInfoRequest(
            token=pb2.Token(
                datasets_token=self._dtoken,
            )
        )
        return self.tstub.GetTokenInfo, req

    def CreateToken(self):
        req = pb2.CreateTokenRequest(
            token=pb2.Token(
                token=self.auth_token,
                type=pb2.Token.ID_TOKEN
            )
        ) #
        return self.tstub.CreateToken, req

    # Users
    def ListUsers(self):
        req = pb2.ListUsersRequest()
        return self.stub.ListUsers, req

    def ListRoles(self):
        req = pb2.ListRolesRequest()
        return self.stub.ListRoles, req

    def DisableUser(self):
        req = pb2.DisableUserRequest(name='users/{}'.format(self._user))
        return self.stub.DisableUser, req

    def EnableUser(self):
        req = pb2.EnableUserRequest(name='users/{}'.format(self._user))
        return self.stub.EnableUser, req

    def GetUser(self):
        req = pb2.GetUserRequest(name='users/{}'.format(self._user))
        return self.stub.GetUser, req

    def ListUserRoles(self):
        req = pb2.ListUserRolesRequest(parent='users/{}'.format(self._user))
        return self.stub.ListUserRoles, req

    def ListUserGroups(self):
        req = pb2.ListUserGroupsRequest(parent='users/{}'.format(self._user))
        return self.stub.ListUserGroups, req

    def AddUserRole(self):
        req = pb2.AddUserRoleRequest(parent='users/{}'.format(self._user), role=pb2.Role(name='roles/runtime.admin'))
        return self.stub.AddUserRole, req

    def RemoveUserRole(self):
        req = pb2.RemoveUserRoleRequest(name='users/{}/roles/runtime.user'.format(self._user))
        return self.stub.RemoveUserRole, req


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        '--method', required=True, help='Method name')
    parser.add_argument(
        '--host', default='localhost', help='The host to connect to')
    parser.add_argument(
        '--port', type=int, default=8081, help='The port to connect to')
    parser.add_argument(
        '--timeout', type=int, default=30, help='The call timeout, in seconds')
    parser.add_argument(
        '--api_key', default=None, help='The API key to use for the call')
    parser.add_argument(
        '--auth_token', default=None,
        help='The JWT auth token to use for the call')
    args = parser.parse_args()

    client = Client(args.host, args.port, args.api_key, args.auth_token)
    client.run(args.method)
