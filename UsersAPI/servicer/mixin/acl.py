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
# import re

# from future.utils import iteritems

# from bson.objectid import ObjectId

# from grpc import StatusCode
# from google.protobuf import struct_pb2

# from ApiCommon.acl import grant, revoke, hash_str
# import MetricsAPI.metrics_pb2 as pb2
# from MetricsAPI.roles import DATA_ROLES
# from MetricsAPI.servicer import helpers
# from MetricsAPI.tools import authorize


# __all__ = [
#     'AclMixin',
# ]

# log = logging.getLogger(__name__)


# class AclMixin(object):
#     """Implements the Metrics API server."""

#     ###########################################################################
#     #                                    ACL                                  #
#     ###########################################################################

#     @authorize(requires=['METRICS.ACL.READ'])
#     def ListAclRecords(self, request, context, auth):  # noqa
#         """Get a list of acl entries for the project."""
#         np = helpers.NameParser(request.parent)

#         if not all([np.project]):
#             context.abort(StatusCode.INVALID_ARGUMENT, "Invalid name format")

#         project = self._get_project_by_id(
#             np.project,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='acl.read')

#         records = project.get('_acl', {}).get('items', [])

#         return pb2.ListAclRecordsResponse(
#             records=[
#                 pb2.AclRecord(
#                     name='projects/{}/acl/{}'.format(
#                         project.get('_id'),
#                         record.get('subject', '-')),
#                     subject=record.get('subject', '-'),
#                     credentials=[
#                         pb2.AclSubjectCredentials(
#                             name='projects/{}/acl/{}/credentials/{}'.format(
#                                 project.get('_id'),
#                                 record.get('subject', '-'),
#                                 credential),
#                             credential=credential,
#                             creation_time=helpers.to_timestamp(
#                                 details.get('created_at', None)),
#                             granted_by=details.get('granted_by', None),
#                         )
#                         for credential, details in iteritems(
#                             record.get('credentials'))
#                     ],
#                 )
#                 for (_, record) in iteritems(records)
#             ]
#         )

#     @authorize(requires=['METRICS.ACL.UPDATE'])
#     def GrantAclCredentials(self, request, context, auth):  # noqa
#         """Create a new acl entry for the project."""
#         # TODO
#         (project_id,) = re.findall(r"^projects/(.*)$", request.parent)

#         # TODO: verify that subject is valid
#         if request.request.subject == auth['email']:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Invalid subject: self")

#         for credentials in request.request.credentials:
#             # TODO: can also grant credentials independently, not only roles
#             if credentials not in DATA_ROLES:
#                 context.abort(
#                     StatusCode.INVALID_ARGUMENT,
#                     "Invalid credentials: {}".format(credentials))

#         project = self._get_project_by_id(
#             project_id,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='acl.update')

#         project = grant(
#             project,
#             request.request.subject,
#             request.request.credentials,
#             auth['email']
#         )

#         # TODO: Verify that the update happened.
#         self.system_db['projects'].update_one(
#             {'_id': ObjectId(project_id)},
#             {
#                 '$set': {
#                     '_acl': project['_acl']
#                 }
#             }
#         )

#         key = hash_str(request.request.subject)
#         record = project['_acl']['items'][key]

#         return pb2.AclRecord(
#             name='projects/{}/acl/{}'.format(
#                 project.get('_id'),
#                 record.get('subject', '-')),
#             subject=record.get('subject', '-'),
#             credentials=[
#                 pb2.AclSubjectCredentials(
#                     name='projects/{}/acl/{}/credentials/{}'.format(
#                         project.get('_id'),
#                         record.get('subject', '-'),
#                         credential),
#                     credential=credential,
#                     creation_time=helpers.to_timestamp(
#                         details.get('created_at', None)),
#                     granted_by=details.get('granted_by', None),
#                 )
#                 for credential, details in iteritems(
#                     record.get('credentials'))
#             ],
#         )

#     @authorize(requires=['METRICS.ACL.DELETE'])
#     def DeleteAclCredentials(self, request, context, auth):  # noqa
#         """Delete an acl entry from the project."""
#         # TODO
#         print(request.name)
#         (project_id, subject, credential), = re.findall(
#             r"^projects/(.*)/acl/(.*)/credentials/(.*)$", request.name)

#         # TODO: verify that subject is valid
#         if subject == auth['email']:
#             context.abort(
#                 StatusCode.INVALID_ARGUMENT,
#                 "Invalid subject: self")

#         project = self._get_project_by_id(
#             project_id,
#             context=context,
#             subjects=auth['all_subjects'],
#             credentials='acl.delete')

#         # TODO: Log this operation
#         project = revoke(
#             project,
#             subject,
#             credential
#         )

#         # TODO: Verify that the update happened.
#         self.system_db['projects'].update_one(
#             {'_id': ObjectId(project_id)},
#             {
#                 '$set': {
#                     '_acl': project['_acl']
#                 }
#             }
#         )

#         return struct_pb2.Value()
