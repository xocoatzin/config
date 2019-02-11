# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import UsersAPI.api_pb2 as pb2
from UsersAPI.tools import authorize
from UsersAPI.roles import USER_ROLES


__all__ = [
    'RolesMixin',
]


class RolesMixin(object):
    """Implements the Users API server."""

    @authorize(requires=['ROLES.READ'])
    def ListRoles(self, request, context, options):  # noqa
        """Get a list of the available roles."""

        roles = [
            pb2.Role(
                name='role/{}'.format(role),
                id=role,
                description=USER_ROLES[role].get('description')
            )
            for role in USER_ROLES
        ]

        return pb2.ListRolesResponse(
            roles=roles,
            next_page_token=None,
        )
