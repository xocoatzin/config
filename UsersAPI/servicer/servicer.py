# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import logging

import UsersAPI.api_pb2_grpc as pb2_grpc
from UsersAPI.servicer.mixin.tokens import TokensMixin
from UsersAPI.servicer.mixin.roles import RolesMixin
from UsersAPI.servicer.mixin.users import UsersMixin
from UsersAPI.servicer.mixin.groups import GroupsMixin
from google.cloud import datastore


__all__ = [
    'UsersServicer',
]

log = logging.getLogger(__name__)


class UsersServicer(
        RolesMixin,
        TokensMixin,
        UsersMixin,
        GroupsMixin,
        pb2_grpc.UsersServicer):
    """Implements the Users API server."""

    ###########################################################################
    #                                   MISC                                  #
    ###########################################################################

    def __init__(self, secret, datastore_project, datastore_namespace):
        """Constructor.

        Args:
            secret (str): The secret to use for JWT encoding.
        """
        self.secret = secret
        self.dsclient = datastore.Client(
            project=datastore_project,
            namespace=datastore_namespace
        )
