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
# import jwt

# from future.utils import iteritems

# from bson.objectid import ObjectId
# from bson import json_util
# import pymongo

# from grpc import StatusCode
# from google.protobuf import struct_pb2
# from google.protobuf.json_format import MessageToDict

# import MetricsAPI.metrics_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


# __all__ = [
#     'DocumentsMixin',
# ]

# log = logging.getLogger(__name__)


# class DocumentsMixin(object):
#     """Implements the Metrics API server."""

#     ###########################################################################
#     #                                DOCUMENTS                                #
#     ###########################################################################

#     @authorize(requires=['METRICS.DOCUMENTS.READ'])
#     def ListDocuments(self, request, context, auth):  # noqa
#         """Get a list of document."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         is_view = np.view is not None
#         after = None
#         if request.page_token:
#             try:
#                 page_token = jwt.decode(
#                     request.page_token, self.secret, algorithms=['HS256'])
#                 after = page_token.get('after')
#             except Exception:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "Invalid page token")

#         page_size = request.page_size if request.page_size is not None else 20
#         if not 0 < page_size <= 100:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Limit should be in the [1-100] range")

#         # TODO: Cache ACL lookup
#         # Ignore results, load only for ACL validation.
#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.read')

#         # Find projects where the user (or any of its groups) is given access
#         query = {}
#         conditions = []

#         # Pagination
#         if after:
#             conditions.append({'_id': {"$gt": ObjectId(after)}})

#         if request.filter:
#             try:
#                 filter_body = json.loads(request.filter)
#                 helpers.verify_filter(filter_body)
#                 conditions.append(filter_body)
#             except json.decoder.JSONDecodeError:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "'filter' should be a valid JSON object")
#             except Exception as e:
#                 context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         if len(conditions) > 0:
#             query = {"$and": conditions}

#         if is_view:
#             mongo_collection_or_view = np.get_view_name()
#         else:
#             mongo_collection_or_view = np.get_collection_name()

#         documents = self.client_db[mongo_collection_or_view].find(
#             query).limit(page_size)
#         documents = list(documents)

#         next_page_token = None
#         if len(documents) == page_size:
#             last_id = documents[-1].get('_id')
#             if last_id:
#                 next_page_token = jwt.encode(
#                     {
#                         'after': str(documents[-1]['_id'])
#                     },
#                     self.secret, algorithm='HS256')
#             else:
#                 log.debug('Pagination not available: missing doc ID')

#         document_list = [
#             helpers.doc2document(
#                 doc, np.project, np.collection, native_doc=not is_view)
#             for doc in documents
#         ]

#         return pb2.ListDocumentsResponse(
#             documents=document_list,
#             next_page_token=next_page_token
#         )

#     @authorize(requires=['METRICS.DOCUMENTS.READ'])
#     def StreamListDocuments(self, request, context, auth):  # noqa
#         """Get a list of document."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project, np.collection]):
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT, "Invalid parent format")

#         # TODO: Cache ACL lookup
#         # Ignore results, load only for ACL validation.
#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.read')

#         # Find projects where the user (or any of its groups) is given access
#         query = {}
#         conditions = []

#         if request.filter:
#             try:
#                 filter_body = json.loads(request.filter)
#                 helpers.verify_filter(filter_body)
#                 conditions.append(filter_body)
#             except json.decoder.JSONDecodeError:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "'filter' should be a valid JSON object")
#             except Exception as e:
#                 context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         if len(conditions) > 0:
#             query = {"$and": conditions}

#         mongo_collection = "{}@{}".format(np.project, np.collection)
#         documents = self.client_db[mongo_collection].find(query)

#         for doc in documents:
#             yield helpers.doc2document(doc, np.project, np.collection)

#     def _aggregate_documents(self, request, context, auth):
#         request = MessageToDict(request)
#         np = helpers.NameParser(request.get('parent'))

#         if not all([np.project, np.collection]):
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT, "Invalid parent format")

#         # TODO: Cache ACL lookup
#         # Ignore results, load only for ACL validation.
#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.read')

#         try:
#             pipeline = helpers.sanitize_pipeline(
#                 request.get('pipeline', {}).get('stages', []))
#         except Exception as e:
#             context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         log.info(
#             'Executing aggregation pipeline: {}'.format(json.dumps(pipeline)))

#         mongo_collection = np.get_collection_name()
#         try:
#             cursor = self.client_db[mongo_collection].aggregate(
#                 pipeline,
#                 maxTimeMS=500,
#                 # batchSize=100,
#             )
#         except Exception as e:
#             context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         # next_page_token = None
#         # if len(documents) == page_size:
#         #     next_page_token = jwt.encode(
#         #         {
#         #             'after': str(documents[-1]['_id'])
#         #         },
#         #         self.secret, algorithm='HS256')

#         for document in cursor:
#             yield pb2.Document(
#                 payload=json.dumps(document, default=json_util.default)
#             )

#     @authorize(requires=['METRICS.DOCUMENTS.AGGREGATE'])
#     def AggregateDocuments(self, request, context, auth):  # noqa
#         """Aggregate documents using aggregation pipeline."""
#         document_list = list(self._aggregate_documents(request, context, auth))

#         return pb2.ListDocumentsResponse(
#             documents=document_list,
#             # next_page_token=next_page_token
#         )

#     @authorize(requires=['METRICS.DOCUMENTS.AGGREGATE'])
#     def StreamAggregateDocuments(self, request, context, auth):  # noqa
#         """Aggregate documents using aggregation pipeline."""
#         for document in self._aggregate_documents(request, context, auth):
#             yield document

#     @authorize(requires=['METRICS.DOCUMENTS.CREATE'])
#     def CreateDocument(self, request, context, auth):  # noqa
#         """Create a new document."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project, np.collection]):
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT, "Invalid parent format")

#         # TODO: Cache ACL lookup .
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.create')

#         # Find the collection in the array.
#         collection = next((
#             col for col in project['collections']
#             if col['_id'] == np.collection), None)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         try:
#             document, warnings = helpers.parse_document(
#                 collection, request.document)
#         except Exception as e:
#             context.abort(StatusCode.INVALID_ARGUMENT, str(e))

#         mongo_collection = np.get_collection_name()
#         doc_id = self.client_db[mongo_collection].insert_one(
#             document).inserted_id
#         document['_id'] = doc_id

#         return helpers.doc2document(
#             document, np.project, np.collection, warnings=warnings)

#     @authorize(requires=['METRICS.DOCUMENTS.CREATE'])
#     def StreamCreateDocument(self, request_iterator, context, auth):  # noqa
#         """Create a new document."""

#         projects = {}
#         collections = {}
#         # all_labels = set()

#         for request in request_iterator:
#             np = helpers.NameParser(request.parent)

#             if not all([np.project, np.collection]):
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT, "Invalid parent format")

#             # TODO: Cache ACL lookup
#             # Ignore results, load only for ACL validation.
#             if np.project not in projects:
#                 projects[np.project] = self._get_project_by_id(
#                     np.project,
#                     context=context,
#                     subjects=auth['all_subjects'],
#                     credentials='document.create')

#             def _parse_labels(labels):
#                 out = {}
#                 for label, value in iteritems(labels):
#                     name, value = helpers.parse_label(label, value)
#                     out[name] = value
#                 return out

#             try:
#                 labels = _parse_labels(dict(request.document.labels))
#             except Exception as e:
#                 context.abort(StatusCode.INVALID_ARGUMENT, str(e))
#             labels['created'] = arrow.get().datetime

#             payload_raw = request.document.payload
#             payload_format = request.document.format

#             payload = {}
#             if payload_format in [
#                     pb2.Document.FORMAT_UNSPECIFIED, pb2.Document.TEXT]:
#                 payload = {
#                     "text": payload_raw or ""
#                 }
#             elif payload_format in [pb2.Document.JSON]:
#                 try:
#                     payload = json.loads(payload_raw or "{}")
#                 except Exception:
#                     context.abort(
#                         StatusCode.INVALID_ARGUMENT, "Invalid JSON payload")

#             document = {
#                 'labels': labels,
#                 'payload': payload
#             }

#             mongo_collection = np.get_collection_name()

#             doc_id = self.client_db[mongo_collection].insert_one(
#                 document).inserted_id
#             document['_id'] = doc_id

#             if mongo_collection not in collections:
#                 collections[mongo_collection] = {'labels': set()}
#             collections[mongo_collection]['labels'] = \
#                 collections[mongo_collection]['labels'].union(list(labels))

#             yield helpers.doc2document(document, np.project, np.collection)

#         # Create indices
#         for collection in collections:
#             indexes = [
#                 pymongo.IndexModel(
#                     'labels.{}'.format(label),  # field name
#                     # name='labels_{}_index'.format(label),
#                     background=True,
#                 )
#                 for label in collections[collection]['labels']
#                 # Exclude labels already indexed
#                 if label not in ['created']
#             ]
#             self.client_db[collection].create_indexes(indexes)
#             log.debug("Created {} indexes in collection: {}".format(
#                 len(indexes), collection))

#     @authorize(requires=['METRICS.DOCUMENTS.READ'])
#     def GetDocument(self, request, context, auth):  # noqa
#         """Return a document, by ID."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project, np.collection, np.document]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Cache ACL lookup
#         # Ignore results, load only for ACL validation.
#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.read')

#         mongo_collection = np.get_collection_name()
#         document = self.client_db[mongo_collection].find_one(
#             {'_id': ObjectId(np.document)})

#         if not document:
#             context.abort(StatusCode.NOT_FOUND, "Document not found")

#         return helpers.doc2document(document, np.project, np.collection)

#     @authorize(requires=['METRICS.DOCUMENTS.DELETE'])
#     def DeleteDocument(self, request, context, auth):  # noqa
#         """Delete a document."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project, np.collection, np.document]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Cache ACL lookup
#         # Ignore results, load only for ACL validation.
#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='document.delete')

#         mongo_collection = np.get_collection_name()
#         result = self.client_db[mongo_collection].delete_one(
#             {'_id': ObjectId(np.document)}
#         )

#         if result.deleted_count != 1:
#             context.abort(StatusCode.NOT_FOUND, "Document not found")

#         return struct_pb2.Value()
