# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

from enum import Enum

USER_ROLES = {
    'users.user': {
        'description': 'User for Datasets Users API',
    },
    'users.admin': {
        'description': 'Admin for Datasets Users API',
    },
    'recordings.user': {
        'description': 'User for Datasets Recordings API',
    },
    'recordings.admin': {
        'description': 'Admin for Datasets Recordings API',
    },
    'metrics.user': {
        'description': 'User for Datasets Metrics API',
    },
    'metrics.admin': {
        'description': 'Admin for Datasets Metrics API',
    },
    'runtime.user': {
        'description': 'User for Datasets Runtime API',
    },
    'runtime.admin': {
        'description': 'Admin for Datasets Runtime API',
    },
    'runtime.executor': {
        'description': 'Executor for Datasets Runtime API',
    },
}


class ApiCredentials(Enum):
    """Definition of the credentials that can be granted to each role."""

    # Can read the list of roles that can be granted to users
    ROLES_READ = 'ROLES_READ'
    # Can read users
    USERS_READ = 'USERS_READ'
    # Can update users
    USERS_UPDATE = 'USERS_UPDATE'
    # Can enable a disabled user account
    USERS_ENABLE = 'USERS_ENABLE'
    # Can disable user accounts
    USERS_DISABLE = 'USERS_DISABLE'
    # Can delete an existing user account
    USERS_DELETE = 'USERS_DELETE'
    # Can add a role to an existing user account
    USERS_ROLES_ADD = 'USERS_ROLES_ADD'
    # Can read the roles for an existing user account
    USERS_ROLES_READ = 'USERS_ROLES_READ'
    # Can remove a role from an existing user account
    USERS_ROLES_REMOVE = 'USERS_ROLES_REMOVE'

# WIP
API_ROLES = {
    'users.user': [
        ApiCredentials.ROLES_READ,
        ApiCredentials.USERS_READ,
    ],
    'users.admin': [
        ApiCredentials.ROLES_READ,
        ApiCredentials.USERS_READ,
        ApiCredentials.USERS_UPDATE,
        ApiCredentials.USERS_ENABLE,
        ApiCredentials.USERS_DISABLE,
        ApiCredentials.USERS_DELETE,
        ApiCredentials.USERS_ROLES_ADD,
        ApiCredentials.USERS_ROLES_READ,
        ApiCredentials.USERS_ROLES_REMOVE,
    ],
}
