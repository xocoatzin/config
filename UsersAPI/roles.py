# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

# WIP
# ROLES have CREDENTIALS
DATA_ROLES = {
    'ROLE:PROJECT:OWNER': [
        # 'project.read',
        # 'project.update',
        # 'project.delete',
        # # 'acl.create',
        # 'acl.read',
        # 'acl.update',
        # 'acl.delete',
        # 'collection.create',
        # 'collection.read',
        # 'collection.update',
        # 'collection.delete',
        # 'view.create',
        # 'view.read',
        # 'view.delete',
        # 'document.create',
        # 'document.read',
        # 'document.update',
        # 'document.delete',
    ],
    'ROLE:PROJECT:PUBLISHER': [
        'document.create',
    ]
}

# WIP
API_ROLES = {
    'users.user': [
        # 'METRICS.USER',
        # 'METRICS.PROJECTS.CREATE',
        # 'METRICS.PROJECTS.READ',
        # 'METRICS.PROJECTS.UPDATE',
        # 'METRICS.PROJECTS.DELETE',
        # # 'METRICS.ACL.CREATE',
        # 'METRICS.ACL.READ',
        # 'METRICS.ACL.UPDATE',
        # 'METRICS.ACL.DELETE',
        # 'METRICS.COLLECTIONS.CREATE',
        # 'METRICS.COLLECTIONS.READ',
        # 'METRICS.COLLECTIONS.UPDATE',
        # 'METRICS.COLLECTIONS.DELETE',
        # 'METRICS.VIEWS.CREATE',
        # 'METRICS.VIEWS.READ',
        # 'METRICS.VIEWS.DELETE',
        # 'METRICS.DOCUMENTS.CREATE',
        # 'METRICS.DOCUMENTS.READ',
        # 'METRICS.DOCUMENTS.SEARCH',
        # 'METRICS.DOCUMENTS.AGGREGATE',
        # # 'METRICS.DOCUMENTS.UPDATE',
        # 'METRICS.DOCUMENTS.DELETE',
    ],
    'users.admin': [
        # 'METRICS.ADMIN',
    ],
}
