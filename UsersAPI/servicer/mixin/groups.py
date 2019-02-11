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

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize
from UsersAPI.servicer import helpers


__all__ = [
    'GroupsMixin',
]


class GroupsMixin(object):
    """Implements the Users API server."""

    @authorize(requires=['GROUPS.CREATE'])
    def CreateGroup(self, request, context, options):  # noqa
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
            'created_by': options.auth.get('email'),
        })
        self.dsclient.put(entity)

        return helpers.group_to_pb2(entity)

    @authorize(requires=['GROUPS.READ'])
    def ListGroups(self, request, context, options):  # noqa
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
            helpers.group_to_pb2(item)
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
    def GetGroup(self, request, context, options):  # noqa
        """List members from a group."""
        request = MessageToDict(request)
        name_parts = helpers.parse_name(request.get('name'))
        group_id = name_parts.get('groups')

        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group ID")

        key = self.dsclient.key('Group', group_id)
        entity = self.dsclient.get(key)

        if not entity:
            context.abort(StatusCode.NOT_FOUND, "Not found")

        return helpers.group_to_pb2(entity)

    @authorize(requires=['GROUPS.MEMBERS.READ'])
    def ListMemberships(self, request, context, options):  # noqa
        """List members from a group."""
        request = MessageToDict(request)
        name_parts = helpers.parse_name(request.get('parent'))

        group_id = name_parts.get('groups')

        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group ID")

        page_size = request.get('pageSize', 100)
        if not 0 < page_size <= 100:
            context.abort(
                StatusCode.INVALID_ARGUMENT,
                "Invalid page size, expected value in range [1-100]")

        page_token = request.get('pageToken')

        ancestor = self.dsclient.key('Group', group_id)
        query = self.dsclient.query(kind='Membership', ancestor=ancestor)
        query_iter = query.fetch(limit=page_size, start_cursor=page_token)
        first_page = next(query_iter.pages)

        memberships = [
            pb2.Membership(
                name='groups/{}/memberships/{}'.format(
                    group_id, entity.get('user_key').name),
                user='users/{}'.format(entity.get('user_key').name),
                created_by=entity.get('created_by'),
                creation_time=helpers.to_pb2_timestamp(
                    entity.get('created_at')),
            )
            for entity in first_page
        ]

        # At the end of the collection, the next page token is equal
        # to the original token
        next_page_token = query_iter.next_page_token.decode("utf-8")
        if next_page_token == page_token:
            next_page_token = None

        return pb2.ListMembershipsResponse(
            memberships=memberships,
            next_page_token=next_page_token,
        )

    @authorize(requires=['GROUPS.MEMBERS.ADD'])
    def AddMembership(self, request, context, options):  # noqa
        """Add a member to a group."""
        request = MessageToDict(request)
        name_parts = helpers.parse_name(request.get('parent'))

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
            'created_by': options.auth.get('email'),
        })
        self.dsclient.put(entity)

        return pb2.Membership(
            name='groups/{}/memberships/{}'.format(group_id, user_id),
            user='users/{}'.format(user_id),
            created_by=options.auth.get('email'),
            creation_time=helpers.to_pb2_timestamp(now),
        )

    @authorize(requires=['GROUPS.MEMBERS.REMOVE'])
    def RemoveMembership(self, request, context, options):  # noqa
        """Remove a member from a group."""
        request = MessageToDict(request)
        name_parts = helpers.parse_name(request.get('name'))

        group_id = name_parts.get('groups')
        if not group_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid group name")

        member_id = name_parts.get('memberships')
        if not member_id:
            context.abort(StatusCode.INVALID_ARGUMENT, "Invalid member name")

        key = self.dsclient.key('Group', group_id, 'Membership', member_id)
        self.dsclient.delete(key)

        return struct_pb2.Value()
