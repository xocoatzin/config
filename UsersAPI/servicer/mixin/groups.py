# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import itertools
import logging
import time

from grpc import StatusCode
from google.cloud import datastore
from google.protobuf import struct_pb2
from google.protobuf.json_format import MessageToDict
from google.protobuf.timestamp_pb2 import Timestamp

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize
# from UsersAPI.roles import USER_ROLES


__all__ = [
    'GroupsMixin',
]

log = logging.getLogger(__name__)


def parse_name(name):
    # TODO: What if null
    return {
        item[0]: item[1]
        for item in itertools.zip_longest(*(iter(name.split('/')),) * 2)
    }


def to_pb2_timestamp(d):
    timestamp = Timestamp()
    timestamp.FromDatetime(datetime.datetime.fromtimestamp(
        time.mktime(d.timetuple())))
    return timestamp


def group_to_pb2(entity):
    return pb2.Group(
        name='groups/{}'.format(entity.key.name),
        title=entity.get('title'),
        description=entity.get('title'),
        creation_time=to_pb2_timestamp(entity.get('created_at')),
        created_by=entity.get('created_by'),
    )


class GroupsMixin(object):
    """Implements the Users API server."""

    @authorize(requires=['GROUPS.CREATE'])
    def CreateGroup(self, request, context, auth):  # noqa
        """Create a new group."""
        request = MessageToDict(request)
        group_id = request.get('groupId')

        if not group_id:  # TODO: Validate ID format
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group id")

        now = datetime.datetime.utcnow()
        key = self.dsclient.key('Group', group_id)

        entity = self.dsclient.get(key)
        if entity is not None:
            context.abort(StatusCode.INVALID_ARGUMENT, "Group already exist")

        entity = datastore.Entity(key=key)
        entity.update({
            'title': request.get('title'),
            'description': request.get('description'),
            'created_at': now,
            'created_by': auth.get('email'),
        })
        self.dsclient.put(entity)

        return group_to_pb2(entity)

    @authorize(requires=['GROUPS.READ'])
    def ListGroups(self, request, context, auth):  # noqa
        """List members from a group."""
        request = MessageToDict(request)

        page_size = request.get('pageSize', 100)
        if not 0 < page_size <= 100:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Invalid page size, expected value in range [1-100]")

        page_token = request.get('pageToken')

        query = self.dsclient.query(kind='Group')

        query_iter = query.fetch(limit=page_size, start_cursor=page_token)
        first_page = next(query_iter.pages)

        groups = [
            group_to_pb2(item)
            for item in first_page
        ]

        # At the end of the collection, the next page token is equal
        # to the original token
        next_page_token = query_iter.next_page_token.decode("utf-8")
        if next_page_token == page_token:
            next_page_token = None

        return pb2.ListGroupsResponse(
            groups=groups,
            next_page_token=next_page_token,
        )

    @authorize(requires=['GROUPS.READ'])
    def GetGroup(self, request, context, auth):  # noqa
        """List members from a group."""
        request = MessageToDict(request)
        name_parts = parse_name(request.get('name'))
        group_id = name_parts.get('groups')

        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group ID")

        key = self.dsclient.key('Group', group_id)
        entity = self.dsclient.get(key)

        if not entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        return group_to_pb2(entity)

    @authorize(requires=['GROUPS.MEMBERS.READ'])
    def ListMemberships(self, request, context, auth):  # noqa
        """List members from a group."""
        request = MessageToDict(request)
        name_parts = parse_name(request.get('parent'))

        group_id = name_parts.get('groups')

        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group ID")

        ancestor = self.dsclient.key('Group', group_id)
        query = self.dsclient.query(kind='Membership', ancestor=ancestor)

        memberships = [
            pb2.Membership(
                name='groups/{}/memberships/{}'.format(
                    group_id, entity.get('user_key').name),
                user='users/{}'.format(entity.get('user_key').name),
                created_by=entity.get('created_by'),
                creation_time=to_pb2_timestamp(entity.get('created_at')),
            )
            for entity in query.fetch(limit=100)  # TODO: Paginate
        ]
        return pb2.ListMembershipsResponse(
            memberships=memberships,
            next_page_token=None,  # TODO
        )

    @authorize(requires=['GROUPS.MEMBERS.ADD'])
    def AddMembership(self, request, context, auth):  # noqa
        """Add a member to a group."""
        request = MessageToDict(request)
        name_parts = parse_name(request.get('parent'))

        group_id = name_parts.get('groups')
        # TODO: chech if the group exists
        # TODO: chech if the user exists

        # users/foo@magicleap.com
        user_id = request.get('membership', {}).get('user')
        if user_id.startswith('users/'):
            user_id = user_id.lstrip('users/')

        now = datetime.datetime.utcnow()

        key = self.dsclient.key('Group', group_id, 'Membership', user_id)
        entity = datastore.Entity(key=key)
        entity.update({
            'user_key': self.dsclient.key('User', user_id),
            'created_at': now,
            'created_by': auth.get('email'),
        })
        self.dsclient.put(entity)

        return pb2.Membership(
            name='groups/{}/memberships/{}'.format(group_id, user_id),
            user='users/{}'.format(user_id),
            created_by=auth.get('email'),
            creation_time=to_pb2_timestamp(now),
        )

    @authorize(requires=['GROUPS.MEMBERS.REMOVE'])
    def RemoveMembership(self, request, context, auth):  # noqa
        """Remove a member from a group."""
        request = MessageToDict(request)
        name_parts = parse_name(request.get('name'))

        group_id = name_parts.get('groups')
        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group name")

        member_id = name_parts.get('memberships')
        if not member_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid member name")

        key = self.dsclient.key('Group', group_id, 'Membership', member_id)
        self.dsclient.delete(key)

        return struct_pb2.Value()

    #     name_parts = parse_name(request.get('name'))

    #     user_id = name_parts.get('users')

    #     if not user_id:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

    #     if user_id in ['me']:
    #         user_id = auth.get('email')

    #     # Only admins can get info from other users.
    #     if user_id != auth.get('email') and \
    #             'users.admin' not in auth.get('roles', []):
    #         context.abort(StatusCode.PERMISSION_DENIED, "Unauthorized")

    #     # user_id = 'atorresgomez@magicleap.com'
    #     user_key = self.dsclient.key('User', user_id)
    #     user_entity = self.dsclient.get(user_key)

    #     if not user_entity:
    #         context.abort(StatusCode.NOT_FOUND, "Not found")

    #     def user_to_pb2(entity):

    #         def to_utc(d):
    #             import time
    #             import datetime
    #             return datetime.datetime.fromtimestamp(
    #                 time.mktime(d.timetuple()))

    #         created_at = Timestamp()
    #         created_at.FromDatetime(to_utc(user_entity.get('created_at')))

    #         last_seen = Timestamp()
    #         last_seen.FromDatetime(to_utc(user_entity.get('last_seen')))

    #         return pb2.User(
    #             name='users/{}'.format(user_entity.get('email')),
    #             email=user_entity.get('email'),
    #             full_name=user_entity.get('full_name'),
    #             given_name=user_entity.get('given_name'),
    #             family_name=user_entity.get('family_name'),
    #             picture=user_entity.get('picture'),
    #             locale=user_entity.get('locale'),
    #             disabled=user_entity.get('disabled'),
    #             creation_time=created_at,
    #             last_seen_time=last_seen,
    #             # roles=user_entity.get('roles'),  # TODO
    #             # groups=user_entity.get('groups'),
    #         )

    #     return user_to_pb2(user_entity)

    # @authorize(requires=['USERS.USERS.ROLES.READ'])
    # def ListUserRoles(self, request, context, auth):  # noqa
    #     """List the roles from a user."""
    #     request = MessageToDict(request)

    #     name_parts = parse_name(request.get('parent'))

    #     # request.get('page_size')
    #     # request.get('page_token')

    #     user_id = name_parts.get('users')

    #     if not user_id:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

    #     ancestor = self.dsclient.key('User', user_id)
    #     query = self.dsclient.query(kind='UserRole', ancestor=ancestor)

    #     roles = [
    #         pb2.Role(
    #             name='users/{}/roles/{}'.format(user_id, entity.key.name),
    #             key=entity.key.name,
    #             description=USER_ROLES.get(
    #                 entity.key.name, {}).get('description')
    #         )
    #         for entity in query.fetch(limit=100)  # TODO: Paginate
    #     ]
    #     return pb2.ListUserRolesResponse(roles=roles, next_page_token=None)

    # @authorize(requires=['USERS.USERS.ROLES.ADD'])
    # def AddUserRole(self, request, context, auth):  # noqa
    #     """Add a role to a user."""
    #     request = MessageToDict(request)

    #     name_parts = parse_name(request.get('parent'))
    #     user_id = name_parts.get('users')

    #     if not user_id:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

    #     role_parts = parse_name(request.get('role', {}).get('name'))
    #     role = role_parts.get('roles')

    #     if not role or role not in USER_ROLES:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid role name")

    #     user_key = self.dsclient.key('User', user_id)
    #     user_entity = self.dsclient.get(user_key)

    #     if not user_entity:
    #         context.abort(StatusCode.NOT_FOUND, "Not found")

    #     now = datetime.datetime.utcnow()
    #     key = self.dsclient.key('User', user_id, 'UserRole', role)
    #     entity = datastore.Entity(key=key)
    #     entity.update({
    #         'granted_at': now,
    #         'granted_by': auth.get('email'),
    #     })
    #     self.dsclient.put(entity)

    #     return pb2.Role(
    #         name='users/{}/roles/{}'.format(user_id, role),
    #         key=role,
    #         description=USER_ROLES.get(role, {}).get('description')
    #     )

    # @authorize(requires=['USERS.USERS.ROLES.REMOVE'])
    # def RemoveUserRole(self, request, context, auth):  # noqa
    #     """Remove a role from a user."""
    #     request = MessageToDict(request)

    #     name_parts = parse_name(request.get('name'))
    #     user_id = name_parts.get('users')
    #     role = name_parts.get('roles')

    #     if not user_id:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid user name")

    #     if not role:
    #         context.abort(StatusCode.INVALID_ARGUMENT, "Invalid role name")

    #     key = self.dsclient.key('User', user_id, 'UserRole', role)
    #     self.dsclient.delete(key)

    #     return struct_pb2.Value()
