# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import logging


# from grpc import StatusCode

# from ApiCommon.acl import invert_roles

import UsersAPI.api_pb2_grpc as pb2_grpc
from UsersAPI.servicer.mixin.tokens import TokensMixin

__all__ = [
    'UsersServicer',
]

log = logging.getLogger(__name__)


class UsersServicer(
        TokensMixin,
        pb2_grpc.UsersServicer):
    """Implements the Users API server."""

    ###########################################################################
    #                                   MISC                                  #
    ###########################################################################

    def __init__(self, secret):
        """Constructor.

        Args:
            secret (str): The secret to use for JWT encoding.
        """
        self.secret = secret
