# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: api.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from google.api import annotations_pb2 as google_dot_api_dot_annotations__pb2
from google.protobuf import empty_pb2 as google_dot_protobuf_dot_empty__pb2
from google.protobuf import timestamp_pb2 as google_dot_protobuf_dot_timestamp__pb2
from google.protobuf import field_mask_pb2 as google_dot_protobuf_dot_field__mask__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='api.proto',
  package='magicleap.datasets.users',
  syntax='proto3',
  serialized_options=None,
  serialized_pb=_b('\n\tapi.proto\x12\x18magicleap.datasets.users\x1a\x1cgoogle/api/annotations.proto\x1a\x1bgoogle/protobuf/empty.proto\x1a\x1fgoogle/protobuf/timestamp.proto\x1a google/protobuf/field_mask.proto\"\xe1\x01\n\x05Token\x12\r\n\x05token\x18\x01 \x01(\t\x12\x37\n\x04type\x18\x02 \x01(\x0e\x32).magicleap.datasets.users.Token.TokenType\x12\x33\n\x0f\x65xpiration_time\x18\x03 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\"[\n\tTokenType\x12\x1a\n\x16TOKEN_TYPE_UNSPECIFIED\x10\x00\x12\x10\n\x0c\x41\x43\x43\x45SS_TOKEN\x10\x01\x12\x0c\n\x08ID_TOKEN\x10\x02\x12\x12\n\x0e\x44\x41TASETS_TOKEN\x10\x03\"D\n\x12\x43reateTokenRequest\x12.\n\x05token\x18\x01 \x01(\x0b\x32\x1f.magicleap.datasets.users.Token2\x84\x01\n\x05Users\x12{\n\x0b\x43reateToken\x12,.magicleap.datasets.users.CreateTokenRequest\x1a\x1f.magicleap.datasets.users.Token\"\x1d\x82\xd3\xe4\x93\x02\x17\"\x0e/api/v1/tokens:\x05tokenb\x06proto3')
  ,
  dependencies=[google_dot_api_dot_annotations__pb2.DESCRIPTOR,google_dot_protobuf_dot_empty__pb2.DESCRIPTOR,google_dot_protobuf_dot_timestamp__pb2.DESCRIPTOR,google_dot_protobuf_dot_field__mask__pb2.DESCRIPTOR,])



_TOKEN_TOKENTYPE = _descriptor.EnumDescriptor(
  name='TokenType',
  full_name='magicleap.datasets.users.Token.TokenType',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='TOKEN_TYPE_UNSPECIFIED', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='ACCESS_TOKEN', index=1, number=1,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='ID_TOKEN', index=2, number=2,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='DATASETS_TOKEN', index=3, number=3,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=300,
  serialized_end=391,
)
_sym_db.RegisterEnumDescriptor(_TOKEN_TOKENTYPE)


_TOKEN = _descriptor.Descriptor(
  name='Token',
  full_name='magicleap.datasets.users.Token',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='token', full_name='magicleap.datasets.users.Token.token', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='type', full_name='magicleap.datasets.users.Token.type', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='expiration_time', full_name='magicleap.datasets.users.Token.expiration_time', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _TOKEN_TOKENTYPE,
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=166,
  serialized_end=391,
)


_CREATETOKENREQUEST = _descriptor.Descriptor(
  name='CreateTokenRequest',
  full_name='magicleap.datasets.users.CreateTokenRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='token', full_name='magicleap.datasets.users.CreateTokenRequest.token', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=393,
  serialized_end=461,
)

_TOKEN.fields_by_name['type'].enum_type = _TOKEN_TOKENTYPE
_TOKEN.fields_by_name['expiration_time'].message_type = google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP
_TOKEN_TOKENTYPE.containing_type = _TOKEN
_CREATETOKENREQUEST.fields_by_name['token'].message_type = _TOKEN
DESCRIPTOR.message_types_by_name['Token'] = _TOKEN
DESCRIPTOR.message_types_by_name['CreateTokenRequest'] = _CREATETOKENREQUEST
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

Token = _reflection.GeneratedProtocolMessageType('Token', (_message.Message,), dict(
  DESCRIPTOR = _TOKEN,
  __module__ = 'api_pb2'
  # @@protoc_insertion_point(class_scope:magicleap.datasets.users.Token)
  ))
_sym_db.RegisterMessage(Token)

CreateTokenRequest = _reflection.GeneratedProtocolMessageType('CreateTokenRequest', (_message.Message,), dict(
  DESCRIPTOR = _CREATETOKENREQUEST,
  __module__ = 'api_pb2'
  # @@protoc_insertion_point(class_scope:magicleap.datasets.users.CreateTokenRequest)
  ))
_sym_db.RegisterMessage(CreateTokenRequest)



_USERS = _descriptor.ServiceDescriptor(
  name='Users',
  full_name='magicleap.datasets.users.Users',
  file=DESCRIPTOR,
  index=0,
  serialized_options=None,
  serialized_start=464,
  serialized_end=596,
  methods=[
  _descriptor.MethodDescriptor(
    name='CreateToken',
    full_name='magicleap.datasets.users.Users.CreateToken',
    index=0,
    containing_service=None,
    input_type=_CREATETOKENREQUEST,
    output_type=_TOKEN,
    serialized_options=_b('\202\323\344\223\002\027\"\016/api/v1/tokens:\005token'),
  ),
])
_sym_db.RegisterServiceDescriptor(_USERS)

DESCRIPTOR.services_by_name['Users'] = _USERS

# @@protoc_insertion_point(module_scope)
