# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

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

# WIP
API_ROLES = {
    'users.user': [
        'ROLES.READ',
        'USERS.READ',
    ],
    'users.groupAdm': [
        'GROUPS.CREATE',
        'GROUPS.READ',
        'GROUPS.UPDATE',
        'GROUPS.DELETE',
        'GROUPS.MEMBERS.ADD',
        'GROUPS.MEMBERS.REMOVE',
        'GROUPS.MEMBERS.READ',

        'USERS.GROUPS.READ',
    ],
    'users.admin': [
        'GROUPS.CREATE',
        'GROUPS.READ',
        'GROUPS.UPDATE',
        'GROUPS.DELETE',
        'GROUPS.MEMBERS.ADD',
        'GROUPS.MEMBERS.REMOVE',
        'GROUPS.MEMBERS.READ',

        'USERS.READ',
        'USERS.UPDATE',
        'USERS.ENABLE',
        'USERS.DISABLE',
        'USERS.DELETE',
        'USERS.GROUPS.READ',
        'USERS.ROLES.ADD',
        'USERS.ROLES.READ',
        'USERS.ROLES.REMOVE',
    ],
}
