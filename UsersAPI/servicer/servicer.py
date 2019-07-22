# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import logging


from UsersAPI.lib.magicleap.datasets import users_pb2_grpc as pb2_grpc
from UsersAPI.servicer.mixin.tokens import TokensMixin
from UsersAPI.servicer.mixin.roles import RolesMixin
from UsersAPI.servicer.mixin.users import UsersMixin
from google.cloud import datastore


__all__ = [
    'UsersServicer',
    'TokensServicer',
]

log = logging.getLogger(__name__)


class UsersServicer(
        RolesMixin,
        UsersMixin,
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


class TokensServicer(
        TokensMixin,
        pb2_grpc.TokensServicer):
    """Implements the Tokens API server."""

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
