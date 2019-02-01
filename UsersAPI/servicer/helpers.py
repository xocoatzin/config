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

# import json
# import logging
# import re

# import arrow
# import jsonschema
# from future.utils import iteritems

# from bson import json_util
# from google.protobuf.timestamp_pb2 import Timestamp

# import MetricsAPI.metrics_pb2 as pb2


# # __all__ = [
# #     'to_timestamp',
# #     'doc2project',
# #     'doc2collection',
# #     'doc2view',
# #     'doc2document',
# #     'parse_label',
# #     'parse_document',
# #     'retention_policy_parser',
# #     'admission_policy_parser',
# #     'verify_filter',
# #     'sanitize_pipeline',
# # ]

# log = logging.getLogger(__name__)


# def to_timestamp(datetime):
#     """Convert a datetime object to protobuf."""
#     dt = arrow.get(datetime).datetime.replace(tzinfo=None)

#     ts = Timestamp()
#     ts.FromDatetime(dt)
#     return ts


# def doc2project(document):
#     """Convert a dictionary to a protobuf."""
#     return pb2.Project(
#         name="projects/{}".format(
#             str(document.get('_id', None))),
#         title=document.get('title', None),
#         creation_time=to_timestamp(document.get('creation_time', None)),
#         created_by=document.get('created_by', None),
#         update_time=to_timestamp(document.get('update_time', None)),
#         updated_by=document.get('updated_by', None),
#     )


# def doc2collection(document, project_id):
#     """Convert a dictionary to a protobuf."""
#     retention_policy = document.get('retention_policy', {})

#     # print(">>>>>>>>>>>")
#     # print(retention_policy_mode)
#     retention_policy_mode = retention_policy.get(
#         'mode', 'RETENTION_MODE_UNSPECIFIED')
#     retention_policy_mode_num = \
#         pb2._RETENTIONPOLICY_RETENTIONMODE.values_by_name.get(
#             retention_policy_mode).number

#     admission_policy = document.get('admission_policy', {})

#     admission_policy_mode = admission_policy.get(
#         'mode', 'ADMISSION_UNSPECIFIED')
#     admission_policy_mode_num = \
#         pb2._ADMISSIONPOLICY_ADMISSIONMODE.values_by_name.get(
#             admission_policy_mode).number

#     return pb2.Collection(
#         name="projects/{}/collections/{}".format(
#             str(project_id),
#             str(document['_id'])),
#         title=document.get('title', None),
#         creation_time=to_timestamp(document.get('creation_time', None)),
#         created_by=document.get('created_by', None),
#         update_time=to_timestamp(document.get('update_time', None)),
#         updated_by=document.get('updated_by', None),
#         retention_policy=pb2.RetentionPolicy(
#             mode=retention_policy_mode_num,
#             period_days=retention_policy.get('period_days'),
#             # notification_days=retention_policy.get('notification_days')
#         ),
#         admission_policy=pb2.AdmissionPolicy(
#             mode=admission_policy_mode_num,
#             schema=admission_policy.get('schema')),
#     )


# def doc2view(document, project_id, collection_id):
#     """Convert a dictionary to a protobuf."""
#     return pb2.View(
#         name="projects/{}/collections/{}/views/{}".format(
#             str(project_id),
#             str(collection_id),
#             str(document['_id'])),
#         title=document.get('title', None),
#         creation_time=to_timestamp(document.get('creation_time', None)),
#         created_by=document.get('created_by', None),
#         pipeline=pb2.AggregationPipeline(
#             stages=document.get('pipeline', {}).get('stages', [])
#         )
#     )


# def doc2document(
#         document, project_id, collection_id, warnings=None, native_doc=True):
#     """Convert a dictionary to a protobuf."""
#     def tojson(input_data):
#         try:
#             return json.dumps(input_data)
#         except Exception:
#             return json.dumps(str(input_data))

#     name = None
#     labels = None
#     payload = None
#     if all([project_id, collection_id, document.get('_id'), native_doc]):
#         name = "projects/{}/collections/{}/documents/{}".format(
#             str(project_id),
#             str(collection_id),
#             str(document['_id']))
#         labels = [
#             (label_name, tojson(document['labels'][label_name]))
#             for label_name in document.get('labels', {})
#         ]
#         payload = json.dumps(
#             document.get('payload'),
#             default=json_util.default)
#     else:
#         payload = json.dumps(
#             document,
#             default=json_util.default)

#     warnings = [
#         pb2.Warning(
#             type=type,
#             message=message,
#         )
#         for type, message in (warnings or [])
#     ]

#     return pb2.Document(
#         name=name,
#         labels=labels,
#         payload=payload,
#         warnings=warnings
#     )


# def validate_id_format(id, min_size=3, max_size=20):
#     """Validate that the input ID matches the standard format."""
#     return (
#         re.match(r'^[a-z][a-z0-9-]+[a-z0-9]$', id) is not None and
#         min_size <= len(id) <= max_size
#     )


# class NameParser(object):
#     """Parse a url-like name."""

#     REGEX = (
#         r'^projects/(?P<project>[a-z0-9-]+)'
#         r'(/collections/(?P<collection>[a-z0-9-]+)'
#         r'(/views/(?P<view>[a-z0-9-]+))?'
#         r'(/documents/(?P<document>[a-z0-9-]+))?)?$'
#     )

#     def __init__(self, name):
#         """Constructor."""
#         matches = None
#         if name.strip():
#             matches = re.match(self.REGEX, name)
#         self.project = matches.group('project') if matches else None
#         self.collection = matches.group('collection') if matches else None
#         self.view = matches.group('view') if matches else None
#         self.document = matches.group('document') if matches else None

#     def get_collection_name(self):
#         """."""
#         return "{}/{}".format(self.project, self.collection)

#     def get_view_name(self):
#         """."""
#         return "{}/{}#{}".format(self.project, self.collection, self.view)


# def parse_label(label_name, label_value):
#     """Parse a label with suffix.

#     The name format is "<name>[.<format>]". If the format is not provided, it
#     will default to "str". Possible types are:

#     String: "s", "str", "string"
#     Integer: "i", "int", "integer"
#     Float: "f", "float", "number"
#     Boolean: "b", "bool", "boolean"
#     Date: "d", "date", "datetime", "t", "ts", "time", "timestamp".

#     Args:
#         label_name (str): The name of the label. Can be prefixed with the name
#             of the data type.
#         label_value (str): The value of the label, as a string. If a data
#             type is provided and is different than "str", the value will be
#             cast to that type.

#     Returns:
#         tuple: The name of the value, without suffix, and the value in the
#             requested type.
#     """
#     name = label_name
#     value = label_value

#     # The name can be suffixed with `.<kind>`
#     # Here, we try to extract the kind, or default to 'str'
#     tokens = name.split('.', 1)
#     name, kind = tokens if len(tokens) == 2 else (tokens[0], 'str')
#     kind = kind.lower()

#     cast_value = None
#     try:
#         invalid_chars_in_name = re.findall(r'[^a-zA-Z_]', name)
#         if len(invalid_chars_in_name) > 0:
#             raise Exception(
#                 'Invalid characters in label name: {}'.format(
#                     json.dumps(invalid_chars_in_name)))

#         if kind in ['s', 'str', 'string']:
#             cast_value = str(value)

#         if kind in ['i', 'int', 'integer']:
#             cast_value = int(value)

#         if kind in ['f', 'float', 'number']:
#             cast_value = float(value)

#         if kind in ['b', 'bool', 'boolean']:
#             cast_value = value.lower() in [
#                 'y', 'yes', 'true', 't', '1', 'positive', '+'
#             ]

#         if kind in [
#                 'd', 'date', 'datetime',
#                 't', 'ts', 'time', 'timestamp']:
#             cast_value = arrow.get(value).datetime
#     except Exception as e:
#         raise Exception("Invalid label: {}".format(str(e)))
#     return name, cast_value


# def parse_document(collection, document):
#     """."""
#     def _parse_labels(labels):
#         out = {}
#         for label, value in iteritems(labels):
#             name, value = parse_label(label, value)
#             out[name] = value
#         return out

#     try:
#         labels = _parse_labels(dict(document.labels))
#     except Exception:
#         raise
#     labels['created'] = arrow.get().datetime

#     payload_raw = document.payload
#     payload_format = document.format

#     warnings = []
#     payload = {}
#     if payload_format in [
#             pb2.Document.FORMAT_UNSPECIFIED, pb2.Document.TEXT]:
#         payload = {
#             "text": payload_raw or ""
#         }
#     elif payload_format in [pb2.Document.JSON]:
#         try:
#             payload = json.loads(payload_raw or "{}")
#         except Exception:
#             raise Exception("Invalid JSON payload")

#         adm_policy = collection.get('admission_policy', {})
#         if adm_policy.get('mode') in ['STRICT', 'WARN']:
#             try:
#                 jsonschema.validate(
#                     payload,
#                     json.loads(adm_policy.get('schema', {})))
#             except jsonschema.exceptions.ValidationError as e:
#                 msg = "Failed admission_policy validation: {}".format(
#                     e.message)

#                 if adm_policy.get('mode') == "STRICT":
#                     raise Exception(msg)
#                 if adm_policy.get('mode') == "WARN":
#                     warnings.append(("ADMISSION_POLICY_WARNING", msg))
#     return {
#         'labels': labels,
#         'payload': payload
#     }, warnings


# def retention_policy_parser(policy):
#     """Parse and verify the update policy.

#     Args:
#         policy (RetentionPolicy): A protobuf defining the retention policy.
#     """
#     # notification_days = policy.notification_days
#     # if not 0 <= notification_days <= 30:
#     #     raise Exception(
#     #         "notification_days must be an integer in the range [1-30]")

#     period_days = policy.period_days
#     if not 0 <= period_days <= 365:
#         raise Exception(
#             "period_days must be an integer in the range [1-365]")

#     mode_name = None
#     if policy.mode != 0:  # RETENTION_MODE_UNSPECIFIED = 0
#         tmp = pb2._RETENTIONPOLICY_RETENTIONMODE.values_by_number
#         mode_name = tmp[policy.mode].name

#     return {
#         # 'notification_days': notification_days or None,
#         'period_days': period_days,
#         'mode': mode_name
#     }


# def admission_policy_parser(
#         policy,
#         require_mode=False,
#         require_schema=False,
#         check_schema=True):
#     """Parse and verify the admission policy.

#     Args:
#         policy (AdmissionPolicy): A protobuf defining the admission policy.
#     """
#     if require_schema and not policy.schema:
#         raise Exception("admission_policy.schema is required")

#     schema = policy.schema or '{}'
#     if check_schema:
#         try:
#             tmp = json.loads(schema)
#             jsonschema.Draft7Validator.check_schema(tmp)
#         except Exception as e:
#             log.info("Error validating schema: {}".format(str(e)))
#             raise Exception("'schema' must be a valid JSON schema")

#     mode_name = None
#     if policy.mode != 0:  # ADMISSION_UNSPECIFIED = 0
#         tmp = pb2._ADMISSIONPOLICY_ADMISSIONMODE.values_by_number
#         mode_name = tmp[policy.mode].name

#     if mode_name is None and require_mode:
#         raise Exception("admission_policy.mode is required")

#     return {
#         'schema': schema,
#         'mode': mode_name
#     }


# WHITELISTED_OPERATORS = [
#     '$and', '$not', '$nor', '$or',
#     '$eq', '$gt', '$gte', '$lt', '$lte', '$ne', '$in', '$nin',
#     '$exists'
# ]


# def verify_filter(input_filter):
#     """."""
#     if not isinstance(input_filter, dict):
#         return
#         # raise Exception("Expected dictionary")

#     for k, v in iteritems(input_filter):
#         if k.startswith('$'):
#             if k not in WHITELISTED_OPERATORS:
#                 raise Exception("Invalid operator: {}".format(k))
#         elif not k.startswith('labels.'):
#             raise Exception(
#                 "Can only filter by label. Got: {}".format(k))

#         if isinstance(v, dict):
#             verify_filter(v)
#         elif isinstance(v, list):
#             for i in v:
#                 verify_filter(i)


# def sanitize_pipeline(stages):
#     """Sanitize an aggregation pipeline.

#     This function applies checks to ensure that only allowed
#     opperations are executed by the aggregation pipeline.

#     Args:
#         stages (str, list of): A list of stages, each one as a
#             JSON string.
#     """
#     out_pipeline = []

#     allowed_stages = {
#         "$addFields",
#         "$bucket",
#         "$bucketAuto",
#         "$count",
#         "$group",
#         "$limit",
#         "$match",
#         "$project",
#         "$replaceRoot",
#         "$skip",
#         "$sort",
#         "$sortByCount",
#         "$unwind",
#     }
#     for stage in stages:
#         try:
#             try:
#                 stage_dict = json.loads(stage)
#             except Exception:
#                 raise Exception("Can't decode JSON string")

#             if len(stage_dict) != 1:
#                 raise Exception("Wrong number of arguments")

#             if list(stage_dict)[0] not in allowed_stages:
#                 raise Exception("Unknown stage")

#             out_pipeline.append(stage_dict)
#         except Exception as e:
#             raise Exception(
#                 "Invalid stage: {}: {}".format(str(e), stage))
#     return out_pipeline
