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
# import arrow
# import jwt

# from grpc import StatusCode
# from google.protobuf import struct_pb2

# import MetricsAPI.metrics_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


# __all__ = [
#     'CollectionsMixin',
# ]

# log = logging.getLogger(__name__)


# class CollectionsMixin(object):
#     """Implements the Metrics API server."""

#     ###########################################################################
#     #                                COLLECTIONS                              #
#     ###########################################################################

#     @authorize(requires=['METRICS.COLLECTIONS.READ'])
#     def ListCollections(self, request, context, auth):  # noqa
#         """Get a list of collections for the project."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

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

#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='collection.read')

#         collections = project.get('collections', [])

#         # Made-up pagination. TBD.
#         collections_to_return = []
#         more = False
#         for collection in collections:
#             if page_size == 0:
#                 more = True
#                 break

#             if after:
#                 if after == str(collection['_id']):
#                     after = None
#                 continue

#             collections_to_return.append(collection)
#             page_size += -1

#         next_page_token = None
#         if more:
#             next_page_token = jwt.encode(
#                 {
#                     'after': str(collections_to_return[-1]['_id'])
#                 },
#                 self.secret, algorithm='HS256')

#         collections = [
#             helpers.doc2collection(collection, np.project)
#             for collection in collections_to_return
#         ]

#         return pb2.ListCollectionsResponse(
#             collections=collections,
#             next_page_token=next_page_token
#         )

#     @authorize(requires=['METRICS.COLLECTIONS.CREATE'])
#     def CreateCollection(self, request, context, auth):  # noqa
#         """Create a new project."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         if not request.collection_id:
#             context.abort(StatusCode.INVALID_ARGUMENT, "Missing Collection ID")

#         if not helpers.validate_id_format(request.collection_id):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid Collection ID")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='collection.create')

#         np.collection = request.collection_id

#         # Search for the collection, it should not exist.
#         existing_collection = self._find(
#             project.get('collections'),
#             lambda item: item.get('_id') == np.collection)

#         if existing_collection:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Collection ID must be unique for this project")

#         # Validate the collection policies
#         new_collection = request.collection

#         try:
#             ret_policy = helpers.retention_policy_parser(
#                 new_collection.retention_policy)
#             adm_policy = helpers.admission_policy_parser(
#                 new_collection.admission_policy)
#         except Exception as e:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Invalid argument: {}".format(str(e)))

#         # Create the collection document
#         now = arrow.get().datetime
#         collection_id = request.collection_id
#         collection = {
#             '_id': collection_id,
#             'title': new_collection.title,
#             'creation_time': now,
#             'created_by': auth['email'],
#             'update_time': now,
#             'updated_by': auth['email'],
#             'retention_policy': {
#                 'mode': ret_policy.get('mode') or 'DELETE',
#                 'period_days': ret_policy.get('period_days') or 90,
#                 'notification_days': ret_policy.get('notification_days') or 7
#             },
#             'admission_policy': {
#                 'schema': adm_policy.get('schema') or '{}',
#                 'mode': adm_policy.get('mode') or 'OFF',
#             },
#         }

#         result = self.system_db['projects'].update_one(
#             {'_id': np.project},
#             {
#                 '$push': {
#                     'collections': collection
#                 }
#             }
#         )

#         if result.modified_count != 1:
#             log.info("An error occurred updating the document")
#             context.abort(
#                 StatusCode.INTERNAL,
#                 "An error occurred updating the document")

#         mongo_collection = np.get_collection_name()

#         # Create the TTL index for document auto-removal.
#         log.debug("Createad: {}".format(mongo_collection))

#         if collection['retention_policy']['mode'] in ['DELETE']:
#             # Create the label index. This also creates an empty collection.
#             log.debug("Creating ttl_index index.")
#             period_sec = 3600 * 24 * collection[
#                 'retention_policy']['period_days']
#             self.client_db[mongo_collection].create_index(
#                 'labels.created',  # field name
#                 name='ttl_index',
#                 background=True,
#                 expireAfterSeconds=period_sec)

#         # Shard the collection, if available.
#         try:
#             log.debug("Enabiling sharding for collection ...")
#             self.mongo_client.admin.command(
#                 'shardCollection',
#                 'metrics-client.{}'.format(mongo_collection),
#                 key={'_id': 'hashed'})
#             log.debug("Enabiling sharding for collection: OK")
#         except Exception:
#             log.error("Enabiling sharding for collection: ERROR")

#         return helpers.doc2collection(collection, np.project)

#     @authorize(requires=['METRICS.COLLECTIONS.READ'])
#     def GetCollection(self, request, context, auth):  # noqa
#         """Return a project, by ID."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='collection.create')

#         # Find the collection in the array.
#         collection = next((
#             col for col in project['collections']
#             if col['_id'] == np.collection), None)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         return helpers.doc2collection(collection, np.project)

#     @authorize(requires=['METRICS.COLLECTIONS.UPDATE'])
#     def UpdateCollection(self, request, context, auth):  # noqa
#         """Update a project."""
#         np = helpers.NameParser(request.collection.name)

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         mongo_collection = np.get_collection_name()

#         # The update mask paths. Must be provided for partial updates.
#         mask_paths = request.update_mask.paths

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='collection.update')

#         # Find the collection in the array.
#         collection = next((
#             col for col in project['collections']
#             if col['_id'] == np.collection), None)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         now = arrow.get().datetime
#         set_values = {
#             'collections.$.update_time': now,
#             'collections.$.updated_by': auth['email'],
#         }

#         # Apply updates:

#         # Title
#         if 'title' in mask_paths:
#             log.info('Updating: title')
#             set_values['collections.$.title'] = request.collection.title or ""
#             collection['title'] = request.collection.title or ""

#         # Retention policy, period days
#         if 'retention_policy.period_days' in mask_paths:
#             log.info('Updating: retention_policy.period_days')

#             try:
#                 ret_policy = helpers.retention_policy_parser(
#                     request.collection.retention_policy)
#             except Exception as e:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "Invalid argument: {}".format(str(e)))

#             period_sec = 3600 * 24 * ret_policy['period_days']
#             ret_val = self.client_db.command(
#                 'collMod',
#                 mongo_collection,
#                 index={
#                     'name': 'ttl_index',
#                     'background': True,
#                     'expireAfterSeconds': period_sec
#                 })

#             if ret_val.get('ok') != 1.0:
#                 log.info("An error occurred updating the TTL index: {}".format(
#                     ret_val))
#                 context.abort(
#                     StatusCode.INTERNAL,
#                     ("An error occurred updating the document "
#                         "[retention_policy]"))

#             collection['retention_policy']['period_days'] = \
#                 ret_policy['period_days']

#         # Admission policy, mode
#         if 'admission_policy.mode' in mask_paths:
#             log.info('Updating: admission_policy.mode')
#             try:
#                 adm_policy = helpers.admission_policy_parser(
#                     request.collection.admission_policy,
#                     require_mode=True, check_schema=False)
#             except Exception as e:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "Invalid argument: {}".format(str(e)))
#             set_values['collections.$.admission_policy.mode'] = \
#                 adm_policy['mode']
#             collection['admission_policy']['mode'] = adm_policy['mode']

#         # Admission policy, schema
#         if 'admission_policy.schema' in mask_paths:
#             log.info('Updating: admission_policy.schema')
#             try:
#                 adm_policy = helpers.admission_policy_parser(
#                     request.collection.admission_policy, require_schema=True)
#             except Exception as e:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "Invalid argument: {}".format(str(e)))
#             set_values['collections.$.admission_policy.schema'] = \
#                 adm_policy['schema']
#             collection['admission_policy']['schema'] = adm_policy['schema']

#         # Save changes
#         result = self.system_db['projects'].update_one(
#             {'$and': [
#                 {'_id': np.project},
#                 {'collections._id': np.collection}
#             ]},
#             {'$set': set_values}
#         )

#         if result.modified_count != 1:
#             log.info("An error occurred updating the document")
#             context.abort(
#                 StatusCode.INTERNAL,
#                 "An error occurred updating the document")

#         return helpers.doc2collection(collection, np.project)

#     @authorize(requires=['METRICS.COLLECTIONS.DELETE'])
#     def DeleteCollection(self, request, context, auth):  # noqa
#         """Delete a project and all its sub resources."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project, np.collection]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # TODO: Don't load the whole doc.
#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='collection.delete')

#         # Find the collection in the array.
#         collection = next((
#             col for col in project['collections']
#             if col['_id'] == np.collection), None)

#         if collection is None:
#             context.abort(StatusCode.NOT_FOUND, "Collection not found")

#         result = self.system_db['projects'].update_one(
#             {'_id': np.project},
#             {
#                 '$pull': {
#                     'collections': {
#                         '_id': np.collection
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
#         for name in self.client_db.collection_names():
#             col_name = np.get_collection_name()
#             if name == col_name or name.startswith(col_name + "#"):
#                 self.client_db[name].drop()
#                 log.debug("Deleted: {}".format(name))

#         return struct_pb2.Value()
