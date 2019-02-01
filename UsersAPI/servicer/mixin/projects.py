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
# import pymongo

# from grpc import StatusCode
# from google.protobuf import struct_pb2

# from ApiCommon.acl import grant, has_access, invert_roles
# import MetricsAPI.metrics_pb2 as pb2
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize
# from MetricsAPI.roles import DATA_ROLES

# INVERTED_DATA_ROLES = invert_roles(DATA_ROLES)

# __all__ = [
#     'ProjectsMixin',
# ]

# log = logging.getLogger(__name__)


# class ProjectsMixin(object):
#     """Implements the Metrics API server."""

#     ###########################################################################
#     #                                 PROJECTS                                #
#     ###########################################################################

#     @authorize(requires=['METRICS.PROJECTS.READ'])
#     def ListProjects(self, request, context, auth):  # noqa
#         """Get a list of projects."""
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

#         # Find projects where the user (or any of its groups) is given access
#         query = {
#             "_acl.subjects": {
#                 "$elemMatch": {
#                     "$in": auth['all_subjects']
#                 }
#             }
#         }

#         # Pagination
#         if after:
#             query['_id'] = {
#                 "$gt": after
#             }

#         projects = self.system_db['projects'].find(query).limit(page_size)

#         # Retreive all the projects
#         projects = list(projects)

#         next_page_token = None
#         if len(projects) == page_size:
#             next_page_token = jwt.encode(
#                 {
#                     'after': str(projects[-1]['_id'])
#                 },
#                 self.secret, algorithm='HS256')

#         projects_list = [
#             helpers.doc2project(project_doc)
#             for project_doc in projects
#             if has_access(
#                 project_doc,
#                 auth['all_subjects'],
#                 'project.read',
#                 INVERTED_DATA_ROLES)
#         ]

#         return pb2.ListProjectsResponse(
#             projects=projects_list,
#             next_page_token=next_page_token
#         )

#     @authorize(requires=['METRICS.PROJECTS.CREATE'])
#     def CreateProject(self, request, context, auth):  # noqa
#         """Create a new project."""
#         project = request.project

#         id_valid = helpers.validate_id_format(request.project_id)
#         if request.project_id is None or not id_valid:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT, "Invalid Project ID")

#         # TODO: add mongo index
#         now = arrow.get().datetime
#         project_doc = {
#             '_id': request.project_id,
#             'title': project.title,
#             'creation_time': now,
#             'created_by': auth['email'],
#             'update_time': now,
#             'updated_by': auth['email'],
#             'collections': []
#         }

#         # Add the creator to the ACL, as owner.
#         project_doc = grant(
#             project_doc,
#             auth['email'],
#             'ROLE:PROJECT:OWNER',
#             'system@metrics.datasets.magicleap.com'
#         )

#         try:
#             doc_id = self.system_db['projects'].insert_one(
#                 project_doc).inserted_id
#         except pymongo.errors.DuplicateKeyError:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Project ID must be globaly unique")
#         except Exception as e:
#             raise e
#         log.debug("Created: projects/{}".format(doc_id))

#         return helpers.doc2project(project_doc)

#     @authorize(requires=['METRICS.PROJECTS.READ'])
#     def GetProject(self, request, context, auth):  # noqa
#         """Return a project, by ID."""
#         np = helpers.NameParser(request.name)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         project_doc = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='project.read')

#         return helpers.doc2project(project_doc)

#     @authorize(requires=['METRICS.PROJECTS.UPDATE'])
#     def UpdateProject(self, request, context, auth):  # noqa
#         """Update a project."""
#         np = helpers.NameParser(request.project.name)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         # The update mask paths. Must be provided for partial updates.
#         mask_paths = request.update_mask.paths

#         project_doc = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='project.update')

#         now = arrow.get().datetime
#         set_values = {
#             'update_time': now,
#             'updated_by': auth['email'],
#         }

#         if 'title' in mask_paths:
#             set_values['title'] = request.project.title or ""
#             project_doc['title'] = request.project.title or ""

#         result = self.system_db['projects'].update_one(
#             {'_id': np.project},
#             {'$set': set_values}
#         )

#         if result.modified_count != 1:
#             log.info("An error occurred updating the document")
#             context.abort(
#                 StatusCode.INTERNAL,
#                 "An error occurred updating the document")

#         return helpers.doc2project(project_doc)

#     @authorize(requires=['METRICS.PROJECTS.DELETE'])
#     def DeleteProject(self, request, context, auth):  # noqa
#         """Delete a project and all its sub resources."""
#         # Ignore results, load only for ACL validation.
#         np = helpers.NameParser(request.name)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='project.delete')

#         log.info('Deleting project: {}'.format(np.project))
#         result = self.system_db['projects'].delete_one(
#             {'_id': np.project}
#         )

#         # TODO: Clear cache.
#         # TODO: Should this be async?
#         for name in self.client_db.collection_names():
#             if name.startswith("{}@".format(np.project)):  # TODO
#                 self.client_db[name].drop()

#         if result.deleted_count != 1:
#             log.info("An error occurred deleting the document")
#             context.abort(
#                 StatusCode.INTERNAL,
#                 "An error occurred deleting the document")

#         return struct_pb2.Value()
