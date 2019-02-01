# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

from UsersAPI import __version__
from UsersAPI.roles import API_ROLES

from ApiCommon.auth import make_auth_decorator

authorize = make_auth_decorator(
    api_roles=API_ROLES,
    server_version=__version__
)
