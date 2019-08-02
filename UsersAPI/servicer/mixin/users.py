# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime

from grpc import StatusCode
from google.cloud import datastore
from google.protobuf import struct_pb2
from google.protobuf.json_format import MessageToDict

from UsersAPI.lib.magicleap.datasets import users_pb2 as pb2
from UsersAPI.tools import authorize
from UsersAPI.roles import USER_ROLES, ApiCredentials
from UsersAPI.servicer import helpers

__all__ = [
    'UsersMixin',
]


class UsersMixin(object):
    """Implements the Users API server."""

    @authorize(requires=[ApiCredentials.USERS_READ])
    def ListUsers(self, request, context, options):  # noqa
        """Get a user by entity name."""
        request = MessageToDict(request)

        page_size = request.get('pageSize', 100)
        if not 0 < page_size <= 100:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Invalid page size, expected value in range [1-100]")
        page_token = request.get('pageToken')

        query = self.dsclient.query(kind='User')
        query_iter = query.fetch(limit=page_size, start_cursor=page_token)
        first_page = next(query_iter.pages)

        # Display full details only to admins.
        is_admin = 'users.admin' in options.auth.get('roles', [])
        users = [
            helpers.user_to_pb2(entity, is_admin)
            for entity in first_page
        ]

        next_page_token = None
        if query_iter.next_page_token:
            next_page_token = query_iter.next_page_token.decode("utf-8")

        # At the end of the collection, the next page token is equal
        # to the original token
        if next_page_token == page_token:
            next_page_token = None

        return pb2.ListUsersResponse(
            users=users,
            next_page_token=next_page_token
        )

    @authorize(requires=[ApiCredentials.USERS_READ])
    def GetUser(self, request, context, options):  # noqa
        """Get a user by entity name."""
        request = MessageToDict(request)

        name_parts = helpers.parse_name(request.get('name'))

        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        if user_id in ['me']:
            user_id = options.auth.get('email')

        # Only admins can get info from other users.
        if user_id != options.auth.get('email') and \
                'users.admin' not in options.auth.get('roles', []):
            context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized")

        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        # Display full details only to admins.
        is_admin = 'users.admin' in options.auth.get('roles', [])
        return helpers.user_to_pb2(user_entity, is_admin)

    @authorize(requires=[ApiCredentials.USERS_ROLES_READ])
    def ListUserRoles(self, request, context, options):  # noqa
        """List the roles from a user."""
        request = MessageToDict(request)

        name_parts = helpers.parse_name(request.get('parent'))

        page_size = request.get('pageSize', 100)
        if not 0 < page_size <= 100:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Invalid page size, expected value in range [1-100]")
        page_token = request.get('pageToken')

        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        if user_id in ['me']:
            user_id = options.auth.get('email')

        ancestor = self.dsclient.key('User', user_id)
        query = self.dsclient.query(kind='UserRole', ancestor=ancestor)
        query.keys_only()
        query_iter = query.fetch(limit=page_size, start_cursor=page_token)
        first_page = next(query_iter.pages)

        roles = [
            pb2.Role(
                name='users/{}/roles/{}'.format(user_id, entity.key.name),
                id=entity.key.name,
                description=USER_ROLES.get(
                    entity.key.name, {}).get('description')
            )
            for entity in first_page
        ]

        next_page_token = None
        if query_iter.next_page_token:
            next_page_token = query_iter.next_page_token.decode("utf-8")

        # At the end of the collection, the next page token is equal
        # to the original token
        if next_page_token == page_token:
            next_page_token = None

        return pb2.ListUserRolesResponse(
            roles=roles,
            next_page_token=next_page_token
        )

    @authorize(requires=[ApiCredentials.USERS_ROLES_ADD])
    def AddUserRole(self, request, context, options):  # noqa
        """Add a role to a user."""
        request = MessageToDict(request)

        name_parts = helpers.parse_name(request.get('parent'))
        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        role_parts = helpers.parse_name(request.get('role', {}).get('name'))
        role = role_parts.get('roles')

        if not role or role not in USER_ROLES:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid role name")

        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        now = datetime.datetime.utcnow()
        key = self.dsclient.key('User', user_id, 'UserRole', role)
        entity = datastore.Entity(key=key)
        entity.update({
            'granted_at': now,
            'granted_by': options.auth.get('email'),
        })
        self.dsclient.put(entity)

        return pb2.Role(
            name='users/{}/roles/{}'.format(user_id, role),
            id=role,
            description=USER_ROLES.get(role, {}).get('description')
        )

    @authorize(requires=[ApiCredentials.USERS_ROLES_REMOVE])
    def RemoveUserRole(self, request, context, options):  # noqa
        """Remove a role from a user."""
        request = MessageToDict(request)

        name_parts = helpers.parse_name(request.get('name'))
        user_id = name_parts.get('users')
        role = name_parts.get('roles')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        if not role:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid role name")

        key = self.dsclient.key('User', user_id, 'UserRole', role)
        self.dsclient.delete(key)

        return struct_pb2.Value()

    def _set_user_enabled(self, enabled, request, context, options):
        request = MessageToDict(request)

        name_parts = helpers.parse_name(request.get('name'))
        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        now = datetime.datetime.utcnow()
        user_entity.update({
            'disabled': enabled,
            'enabled_at': now,
            'enabled_by': options.auth.get('email'),
        })
        self.dsclient.put(user_entity)

        return helpers.user_to_pb2(user_entity)

    @authorize(requires=[ApiCredentials.USERS_ENABLE])
    def EnableUser(self, request, context, options):  # noqa
        """Enable a user account."""
        self._set_user_enabled(False, request, context, options)

    @authorize(requires=[ApiCredentials.USERS_DISABLE])
    def DisableUser(self, request, context, options):  # noqa
        """Disable a user account."""
        self._set_user_enabled(True, request, context, options)
