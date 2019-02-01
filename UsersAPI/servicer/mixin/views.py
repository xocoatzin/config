# # -*- coding: utf-8 -*-
# """Datasets APIs.

# Style Guide:
#    http://google.github.io/styleguide/pyguide.html
#    http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
# """

# from __future__ import (  # noqa
#     absolute_import, division, print_function, unicode_literals)
# from builtins import (  # noqa
#     ascii, bytes, chr, dict, filter, hex, input, int, map, next, oct, open,
#     pow, range, round, str, super, zip)

# import logging
# import json

# import arrow

# from grpc import StatusCode
# from google.protobuf import struct_pb2
# from google.protobuf.json_format import MessageToDict

# import MetricsAPI.metrics_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


# __all__ = [
#     'ViewsMixin',
# ]

# log = logging.getLogger(__name__)


# class ViewsMixin(object):
#     """Implements the Metrics API server."""

#     ###########################################################################
#     #                                   VIEWS                                 #
#     ###########################################################################

#     def _find(self, the_list, condition):
#         if not the_list:
#             return None
#         return next(
#             (
#                 item for item in the_list
#                 if condition(item)
#             ),
#             None
#         )

#     @authorize(requires=['METRICS.VIEWS.READ'])
#     def ListViews(self, request, context, auth):  # noqa
#         """Get a list of views for the collection."""
#         request = MessageToDict(request)
#         np = helpers.NameParser(request.get('parent'))

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='view.read')

#         collection = self._find(
#             project.get('collections'),
#             lambda item: item.get('_id') == np.collection)

#         next_page_token = None  # TODO: Pagination
#         views = [
#             helpers.doc2view(view, np.project, np.collection)
#             for view in collection.get('views', [])
#         ]

#         return pb2.ListViewsResponse(
#             views=views,
#             next_page_token=next_page_token
#         )

#     @authorize(requires=['METRICS.VIEWS.CREATE'])
#     def CreateView(self, request, context, auth):  # noqa
#         """Create a new view for the collection."""
#         request = MessageToDict(request)
#         np = helpers.NameParser(request.get('parent'))

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='view.create')

#         collection = self._find(
#             project.get('collections'),
#             lambda item: item.get('_id') == np.collection)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         np.view = request.get('viewId')

#         if not np.view:
#             context.abort(StatusCode.INVALID_ARGUMENT, "Missing View ID")

#         if not helpers.validate_id_format(np.view):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid View ID")

#         # Search for the view, it should not exist.
#         existing_view = self._find(
#             collection.get('views'),
#             lambda item: item.get('_id') == np.view)

#         if existing_view:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT, "View ID must be unique")

#         try:
#             pipeline_json_stages = request.get(
#                 'view', {}).get('pipeline', {}).get('stages', [])
#             pipeline = helpers.sanitize_pipeline(pipeline_json_stages)
#         except Exception as e:
#             context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         now = arrow.get().datetime
#         view = {
#             '_id': np.view,
#             'title': request.get('view', {}).get('title', ''),
#             'creation_time': now,
#             'created_by': auth['email'],
#             'pipeline': {
#                 # Store the text version, due to Mongo naming constraints
#                 'stages': [
#                     json.dumps(stage) for stage in pipeline
#                 ]
#             }
#         }

#         # Save changes
#         result = self.system_db['projects'].update_one(
#             {'$and': [
#                 {'_id': np.project},
#                 {'collections._id': np.collection}
#             ]},
#             # {'$set': set_values}
#             {'$push': {'collections.$.views': view}}
#         )

#         if result.modified_count != 1:
#             log.info("An error occurred updating the document")
#             context.abort(StatusCode.INTERNAL, "An error occurred")

#         result = self.client_db.command({
#             "create": np.get_view_name(),
#             "viewOn": np.get_collection_name(),
#             "pipeline": pipeline
#         })
#         # print(result)  -> {'ok': 1.0}

#         return helpers.doc2view(view, np.project, np.collection)

#     @authorize(requires=['METRICS.VIEWS.READ'])
#     def GetView(self, request, context, auth):  # noqa
#         """Get a view by name."""
#         request = MessageToDict(request)
#         np = helpers.NameParser(request.get('name'))

#         if not all([np.project, np.collection, np.view]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='view.read')

#         collection = self._find(
#             project.get('collections'),
#             lambda item: item.get('_id') == np.collection)

#         if not collection:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         # Search for the view.
#         view = self._find(
#             collection.get('views'),
#             lambda item: item.get('_id') == np.view)

#         if not view:
#             context.abort(StatusCode.NOT_FOUND, "View not found")

#         return helpers.doc2view(view, np.project, np.collection)

#     @authorize(requires=['METRICS.VIEWS.DELETE'])
#     def DeleteView(self, request, context, auth):  # noqa
#         """Delete a a view."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project, np.collection, np.view]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='view.delete')

#         # Find the collection in the array.
#         collection = next((
#             col for col in project['collections']
#             if col['_id'] == np.collection), None)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         view = self._find(
#             collection.get('views'),
#             lambda item: item.get('_id') == np.view)

#         if not view:
#             context.abort(StatusCode.NOT_FOUND, "View not found")

#         result = self.system_db['projects'].update_one(
#             {'$and': [
#                 {'_id': np.project},
#                 {'collections._id': np.collection}
#             ]},
#             {
#                 '$pull': {
#                     'collections.$.views': {
#                         '_id': np.view
#                     },
#                 }
#             }
#         )

#         if result.modified_count != 1:
#             log.info("An error occurred updating the document")
#             context.abort(
#                 StatusCode.INTERNAL,
#                 "An error occurred updating the document")

#         # Delete this collection and its views
#         self.client_db[np.get_view_name()].drop()

#         return struct_pb2.Value()
