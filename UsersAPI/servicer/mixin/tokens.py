# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import logging
# import json

# import arrow

# from grpc import StatusCode
# from google.protobuf import struct_pb2
from google.protobuf.json_format import MessageToDict

import UsersAPI.api_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


__all__ = [
    'TokensMixin',
]

log = logging.getLogger(__name__)


class TokensMixin(object):
    """Implements the Users API server."""

    def CreateToken(self, request, context):  # noqa
        """Get a list of views for the collection."""
        request = MessageToDict(request)
        log.info(request)
        log.info({
            meta.key: meta.value
            for meta in context.invocation_metadata()
        })
        # np = helpers.NameParser(request.get('parent'))

        # if not all([np.project, np.collection]):
        #     context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

        # # TODO: Don't load the whole doc.
        # project = self._get_project_by_id(
        #     np.project,
        #     context=context,
        #     subjects=auth['all_subjects'],
        #     credentials='view.read')

        # collection = self._find(
        #     project.get('collections'),
        #     lambda item: item.get('_id') == np.collection)

        # next_page_token = None  # TODO: Pagination
        # views = [
        #     helpers.doc2view(view, np.project, np.collection)
        #     for view in collection.get('views', [])
        # ]
        return pb2.Token(
            token="token",
            # type=views,
            # expiration_time=views,
        )
