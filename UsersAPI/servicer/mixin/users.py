# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import itertools
import logging

from grpc import StatusCode
from google.cloud import datastore
from google.protobuf import struct_pb2
from google.protobuf.json_format import MessageToDict
from google.protobuf.timestamp_pb2 import Timestamp

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize
from UsersAPI.roles import USER_ROLES


__all__ = [
    'UsersMixin',
]

log = logging.getLogger(__name__)


def parse_name(name):
    return {
        item[0]: item[1]
        for item in itertools.zip_longest(*(iter(name.split('/')),) * 2)
    }


def user_to_pb2(entity):

    def to_utc(d):
        import time
        import datetime
        return datetime.datetime.fromtimestamp(
            time.mktime(d.timetuple()))

    created_at = Timestamp()
    created_at.FromDatetime(to_utc(entity.get('created_at')))

    last_seen = Timestamp()
    last_seen.FromDatetime(to_utc(entity.get('last_seen')))

    return pb2.User(
        name='users/{}'.format(entity.get('email')),
        email=entity.get('email'),
        full_name=entity.get('full_name'),
        given_name=entity.get('given_name'),
        family_name=entity.get('family_name'),
        picture=entity.get('picture'),
        locale=entity.get('locale'),
        disabled=entity.get('disabled', False),
        creation_time=created_at,
        last_seen_time=last_seen,
    )


class UsersMixin(object):
    """Implements the Users API server."""

    @authorize(requires=['USERS.READ'])
    def GetUser(self, request, context, auth):  # noqa
        """Get a user by entity name."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('name'))

        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        if user_id in ['me']:
            user_id = auth.get('email')

        # Only admins can get info from other users.
        if user_id != auth.get('email') and \
                'users.admin' not in auth.get('roles', []):
            context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized")

        # user_id = 'atorresgomez@magicleap.com'
        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        return user_to_pb2(user_entity)

    @authorize(requires=['USERS.GROUPS.READ'])
    def ListUserGroups(self, request, context, auth):  # noqa
        """List the roles from a user."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('parent'))

        # request.get('page_size')
        # request.get('page_token')

        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        user_key = self.dsclient.key('User', user_id)
        query = self.dsclient.query(kind='Membership')
        query.keys_only()
        query.add_filter('user_key', '=', user_key)
        groups = [
            pb2.Group(
                name='groups/{}'.format(item.key.parent.name),
            )
            for item in query.fetch()
        ]
        return pb2.ListUserGroupsResponse(groups=groups, next_page_token=None)

    @authorize(requires=['USERS.ROLES.READ'])
    def ListUserRoles(self, request, context, auth):  # noqa
        """List the roles from a user."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('parent'))

        # request.get('page_size')
        # request.get('page_token')

        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        ancestor = self.dsclient.key('User', user_id)
        query = self.dsclient.query(kind='UserRole', ancestor=ancestor)
        query.keys_only()

        roles = [
            pb2.Role(
                name='users/{}/roles/{}'.format(user_id, entity.key.name),
                key=entity.key.name,
                description=USER_ROLES.get(
                    entity.key.name, {}).get('description')
            )
            for entity in query.fetch(limit=None)  # TODO: Paginate
        ]
        return pb2.ListUserRolesResponse(roles=roles, next_page_token=None)

    @authorize(requires=['USERS.ROLES.ADD'])
    def AddUserRole(self, request, context, auth):  # noqa
        """Add a role to a user."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('parent'))
        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        role_parts = parse_name(request.get('role', {}).get('name'))
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
            'granted_by': auth.get('email'),
        })
        self.dsclient.put(entity)

        return pb2.Role(
            name='users/{}/roles/{}'.format(user_id, role),
            key=role,
            description=USER_ROLES.get(role, {}).get('description')
        )

    @authorize(requires=['USERS.ROLES.REMOVE'])
    def RemoveUserRole(self, request, context, auth):  # noqa
        """Remove a role from a user."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('name'))
        user_id = name_parts.get('users')
        role = name_parts.get('roles')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        if not role:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid role name")

        key = self.dsclient.key('User', user_id, 'UserRole', role)
        self.dsclient.delete(key)

        return struct_pb2.Value()

    @authorize(requires=['USERS.ENABLE'])
    def EnableUser(self, request, context, auth):  # noqa
        """Enable a user account."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('name'))
        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        now = datetime.datetime.utcnow()
        user_entity.update({
            'disabled': False,
            'enabled_at': now,
            'enabled_by': auth.get('email'),
        })
        self.dsclient.put(user_entity)

        return user_to_pb2(user_entity)

    @authorize(requires=['USERS.DISABLE'])
    def DisableUser(self, request, context, auth):  # noqa
        """Disable a user account."""
        request = MessageToDict(request)

        name_parts = parse_name(request.get('name'))
        user_id = name_parts.get('users')

        if not user_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

        user_key = self.dsclient.key('User', user_id)
        user_entity = self.dsclient.get(user_key)

        if not user_entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        now = datetime.datetime.utcnow()
        user_entity.update({
            'disabled': True,
            'disabled_at': now,
            'disabled_by': auth.get('email'),
        })
        self.dsclient.put(user_entity)

        return user_to_pb2(user_entity)
