# Flake8: noqa
# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
import grpc

from google.protobuf import empty_pb2 as google_dot_protobuf_dot_empty__pb2
from . import users_pb2 as magicleap_dot_datasets_dot_users__pb2


class TokensStub(object):
  """The Tokens API.
  """

  def __init__(self, channel):
    """Constructor.

    Args:
      channel: A grpc.Channel.
    """
    self.CreateToken = channel.unary_unary(
        '/magicleap.datasets.users.Tokens/CreateToken',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.CreateTokenRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.Token.FromString,
        )
    self.GetTokenInfo = channel.unary_unary(
        '/magicleap.datasets.users.Tokens/GetTokenInfo',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.TokenInfoRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.TokenInfo.FromString,
        )


class TokensServicer(object):
  """The Tokens API.
  """

  def CreateToken(self, request, context):
    """Create a token
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GetTokenInfo(self, request, context):
    """Create a token
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_TokensServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'CreateToken': grpc.unary_unary_rpc_method_handler(
          servicer.CreateToken,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.CreateTokenRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.Token.SerializeToString,
      ),
      'GetTokenInfo': grpc.unary_unary_rpc_method_handler(
          servicer.GetTokenInfo,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.TokenInfoRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.TokenInfo.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'magicleap.datasets.users.Tokens', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))


class UsersStub(object):
  """The Users API.
  """

  def __init__(self, channel):
    """Constructor.

    Args:
      channel: A grpc.Channel.
    """
    self.ListRoles = channel.unary_unary(
        '/magicleap.datasets.users.Users/ListRoles',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.ListRolesRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.ListRolesResponse.FromString,
        )
    self.ListUsers = channel.unary_unary(
        '/magicleap.datasets.users.Users/ListUsers',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.ListUsersRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.ListUsersResponse.FromString,
        )
    self.GetUser = channel.unary_unary(
        '/magicleap.datasets.users.Users/GetUser',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.GetUserRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.User.FromString,
        )
    self.DisableUser = channel.unary_unary(
        '/magicleap.datasets.users.Users/DisableUser',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.DisableUserRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.User.FromString,
        )
    self.EnableUser = channel.unary_unary(
        '/magicleap.datasets.users.Users/EnableUser',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.EnableUserRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.User.FromString,
        )
    self.ListUserRoles = channel.unary_unary(
        '/magicleap.datasets.users.Users/ListUserRoles',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.ListUserRolesRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.ListUserRolesResponse.FromString,
        )
    self.AddUserRole = channel.unary_unary(
        '/magicleap.datasets.users.Users/AddUserRole',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.AddUserRoleRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_users__pb2.Role.FromString,
        )
    self.RemoveUserRole = channel.unary_unary(
        '/magicleap.datasets.users.Users/RemoveUserRole',
        request_serializer=magicleap_dot_datasets_dot_users__pb2.RemoveUserRoleRequest.SerializeToString,
        response_deserializer=google_dot_protobuf_dot_empty__pb2.Empty.FromString,
        )


class UsersServicer(object):
  """The Users API.
  """

  def ListRoles(self, request, context):
    """List available roles
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def ListUsers(self, request, context):
    """List available users
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GetUser(self, request, context):
    """// // Create a new user
    // rpc CreateUser(CreateUserRequest) returns (User) {
    //   option (google.api.http) = {
    //     post: "/api/v1/users"
    //     body: "user"
    //   };
    // }

    Get a user by name
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def DisableUser(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def EnableUser(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def ListUserRoles(self, request, context):
    """List available roles
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def AddUserRole(self, request, context):
    """Add a new role
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def RemoveUserRole(self, request, context):
    """// // Get a role by name
    // rpc GetUserRole(GetUserRoleRequest) returns (Role) {
    //   option (google.api.http) = {
    //     get: "/api/v1/{name=users/*/roles/*}"
    //   };
    // }

    Remove a role
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_UsersServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'ListRoles': grpc.unary_unary_rpc_method_handler(
          servicer.ListRoles,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.ListRolesRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.ListRolesResponse.SerializeToString,
      ),
      'ListUsers': grpc.unary_unary_rpc_method_handler(
          servicer.ListUsers,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.ListUsersRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.ListUsersResponse.SerializeToString,
      ),
      'GetUser': grpc.unary_unary_rpc_method_handler(
          servicer.GetUser,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.GetUserRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.User.SerializeToString,
      ),
      'DisableUser': grpc.unary_unary_rpc_method_handler(
          servicer.DisableUser,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.DisableUserRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.User.SerializeToString,
      ),
      'EnableUser': grpc.unary_unary_rpc_method_handler(
          servicer.EnableUser,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.EnableUserRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.User.SerializeToString,
      ),
      'ListUserRoles': grpc.unary_unary_rpc_method_handler(
          servicer.ListUserRoles,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.ListUserRolesRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.ListUserRolesResponse.SerializeToString,
      ),
      'AddUserRole': grpc.unary_unary_rpc_method_handler(
          servicer.AddUserRole,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.AddUserRoleRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_users__pb2.Role.SerializeToString,
      ),
      'RemoveUserRole': grpc.unary_unary_rpc_method_handler(
          servicer.RemoveUserRole,
          request_deserializer=magicleap_dot_datasets_dot_users__pb2.RemoveUserRoleRequest.FromString,
          response_serializer=google_dot_protobuf_dot_empty__pb2.Empty.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'magicleap.datasets.users.Users', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))
