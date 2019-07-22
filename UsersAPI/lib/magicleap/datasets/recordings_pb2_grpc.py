# Flake8: noqa
# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
import grpc

from google.protobuf import empty_pb2 as google_dot_protobuf_dot_empty__pb2
from . import recordings_pb2 as magicleap_dot_datasets_dot_recordings__pb2


class RecordingsStub(object):
  """The Recordings API.
  """

  def __init__(self, channel):
    """Constructor.

    Args:
      channel: A grpc.Channel.
    """
    self.ListNamespaces = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/ListNamespaces',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListNamespacesRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListNamespacesResponse.FromString,
        )
    self.ListProjects = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/ListProjects',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListProjectsRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListProjectsResponse.FromString,
        )
    self.CreateProject = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/CreateProject',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.CreateProjectRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Project.FromString,
        )
    self.GetProject = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/GetProject',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.GetProjectRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Project.FromString,
        )
    self.UpdateProject = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/UpdateProject',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.UpdateProjectRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Project.FromString,
        )
    self.GrantAccess = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/GrantAccess',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.GrantAccessRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GrantAccessResponse.FromString,
        )
    self.RevokeAccess = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/RevokeAccess',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.RevokeAccessRequest.SerializeToString,
        response_deserializer=google_dot_protobuf_dot_empty__pb2.Empty.FromString,
        )
    self.ListAccess = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/ListAccess',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListAccessRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListAccessResponse.FromString,
        )
    self.CreateRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/CreateRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.CreateRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.GetRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/GetRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.CompleteRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/CompleteRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.CompleteRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.DeleteRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/DeleteRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.DeleteRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.UndeleteRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/UndeleteRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.UndeleteRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.UpdateRecording = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/UpdateRecording',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.UpdateRecordingRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.FromString,
        )
    self.SearchRecordings = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/SearchRecordings',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.SearchRecordingsRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.SearchRecordingsResponse.FromString,
        )
    self.GetRecordingPermissions = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/GetRecordingPermissions',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingPermissionsRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingPermissionsResponse.FromString,
        )
    self.ListFiles = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/ListFiles',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListFilesRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListFilesResponse.FromString,
        )
    self.CreateFileUploadLink = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/CreateFileUploadLink',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.FileLinkRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.StorageLink.FromString,
        )
    self.CreateFileDownloadLink = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/CreateFileDownloadLink',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.FileLinkRequest.SerializeToString,
        response_deserializer=magicleap_dot_datasets_dot_recordings__pb2.StorageLink.FromString,
        )
    self.DeleteFile = channel.unary_unary(
        '/magicleap.datasets.recordings.Recordings/DeleteFile',
        request_serializer=magicleap_dot_datasets_dot_recordings__pb2.DeleteFileRequest.SerializeToString,
        response_deserializer=google_dot_protobuf_dot_empty__pb2.Empty.FromString,
        )


class RecordingsServicer(object):
  """The Recordings API.
  """

  def ListNamespaces(self, request, context):
    """
    Namespaces

    List namespaces
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def ListProjects(self, request, context):
    """// Create a namespace
    rpc CreateNamespace(TODO) returns (TODO) {
    option (google.api.http) = {
    post: "/api/v4/namespaces",
    };
    }

    Get a namespace by name
    rpc GetNamespace(TODO) returns (TODO) {
    option (google.api.http) = {
    get: "/api/v4/{name=namespaces/*}"
    };
    }

    // Delete a namespace
    rpc DeleteNamespace(TODO) returns (TODO) {
    option (google.api.http) = {
    delete: "/api/v4/{name=namespaces/*}",
    };
    }

    // Update an existing namespace
    rpc UpdateNamespace(TODO) returns (TODO) {
    option (google.api.http) = {
    patch: "/api/v4/{namespace.name=namespaces/*}"
    body: "namespace"
    };
    }


    Projects

    List projects
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def CreateProject(self, request, context):
    """Create a project
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GetProject(self, request, context):
    """Get a project by name
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def UpdateProject(self, request, context):
    """// Delete a project
    rpc DeleteProject(TODO) returns (TODO) {
    option (google.api.http) = {
    delete: "/api/v4/{name=namespaces/*/projects/*}",
    };
    }

    Update an existing project
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GrantAccess(self, request, context):
    """
    ACL

    Grant access to a resource
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def RevokeAccess(self, request, context):
    """Revoke access to a resource
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def ListAccess(self, request, context):
    """List access control policies to a resource
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def CreateRecording(self, request, context):
    """
    Recordings

    // List recordings
    rpc ListRecordings(TODO) returns (TODO) {
    option (google.api.http) = {
    get: "/api/v4/{parent=namespaces/*}/recordings",
    };
    }

    Create a recording
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GetRecording(self, request, context):
    """Get a recording by name
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def CompleteRecording(self, request, context):
    """Complete a recording
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def DeleteRecording(self, request, context):
    """Delete a recording
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def UndeleteRecording(self, request, context):
    """Undelete a recording
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def UpdateRecording(self, request, context):
    """Update an existing recording
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def SearchRecordings(self, request, context):
    """Search recordings
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def GetRecordingPermissions(self, request, context):
    """// Suggest search terms
    rpc SuggestSearchRecordings(SuggestSearchRecordingsRequest) returns (SuggestSearchRecordingsResponse) {
    option (google.api.http) = {
    get: "/api/v4/{parent=namespaces/*}/recordings:suggestSearch"
    };
    }

    Get a recording by name
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def ListFiles(self, request, context):
    """
    Files

    // List the storage options for the recording
    rpc ListRecordingStorageOptions(ListRecordingStorageOptionsRequest) returns (ListRecordingStorageOptionsResponse) {
    option (google.api.http) = {
    get: "/api/v4/{parent=namespaces/*/recordings/*}/storageClasses",
    };
    }

    List files
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def CreateFileUploadLink(self, request, context):
    """Create a file upload link
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def CreateFileDownloadLink(self, request, context):
    """Create a file download link
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def DeleteFile(self, request, context):
    """Delete a file
    """
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_RecordingsServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'ListNamespaces': grpc.unary_unary_rpc_method_handler(
          servicer.ListNamespaces,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListNamespacesRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListNamespacesResponse.SerializeToString,
      ),
      'ListProjects': grpc.unary_unary_rpc_method_handler(
          servicer.ListProjects,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListProjectsRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListProjectsResponse.SerializeToString,
      ),
      'CreateProject': grpc.unary_unary_rpc_method_handler(
          servicer.CreateProject,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.CreateProjectRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Project.SerializeToString,
      ),
      'GetProject': grpc.unary_unary_rpc_method_handler(
          servicer.GetProject,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GetProjectRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Project.SerializeToString,
      ),
      'UpdateProject': grpc.unary_unary_rpc_method_handler(
          servicer.UpdateProject,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.UpdateProjectRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Project.SerializeToString,
      ),
      'GrantAccess': grpc.unary_unary_rpc_method_handler(
          servicer.GrantAccess,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GrantAccessRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.GrantAccessResponse.SerializeToString,
      ),
      'RevokeAccess': grpc.unary_unary_rpc_method_handler(
          servicer.RevokeAccess,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.RevokeAccessRequest.FromString,
          response_serializer=google_dot_protobuf_dot_empty__pb2.Empty.SerializeToString,
      ),
      'ListAccess': grpc.unary_unary_rpc_method_handler(
          servicer.ListAccess,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListAccessRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListAccessResponse.SerializeToString,
      ),
      'CreateRecording': grpc.unary_unary_rpc_method_handler(
          servicer.CreateRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.CreateRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'GetRecording': grpc.unary_unary_rpc_method_handler(
          servicer.GetRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'CompleteRecording': grpc.unary_unary_rpc_method_handler(
          servicer.CompleteRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.CompleteRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'DeleteRecording': grpc.unary_unary_rpc_method_handler(
          servicer.DeleteRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.DeleteRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'UndeleteRecording': grpc.unary_unary_rpc_method_handler(
          servicer.UndeleteRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.UndeleteRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'UpdateRecording': grpc.unary_unary_rpc_method_handler(
          servicer.UpdateRecording,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.UpdateRecordingRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.Recording.SerializeToString,
      ),
      'SearchRecordings': grpc.unary_unary_rpc_method_handler(
          servicer.SearchRecordings,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.SearchRecordingsRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.SearchRecordingsResponse.SerializeToString,
      ),
      'GetRecordingPermissions': grpc.unary_unary_rpc_method_handler(
          servicer.GetRecordingPermissions,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingPermissionsRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.GetRecordingPermissionsResponse.SerializeToString,
      ),
      'ListFiles': grpc.unary_unary_rpc_method_handler(
          servicer.ListFiles,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.ListFilesRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.ListFilesResponse.SerializeToString,
      ),
      'CreateFileUploadLink': grpc.unary_unary_rpc_method_handler(
          servicer.CreateFileUploadLink,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.FileLinkRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.StorageLink.SerializeToString,
      ),
      'CreateFileDownloadLink': grpc.unary_unary_rpc_method_handler(
          servicer.CreateFileDownloadLink,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.FileLinkRequest.FromString,
          response_serializer=magicleap_dot_datasets_dot_recordings__pb2.StorageLink.SerializeToString,
      ),
      'DeleteFile': grpc.unary_unary_rpc_method_handler(
          servicer.DeleteFile,
          request_deserializer=magicleap_dot_datasets_dot_recordings__pb2.DeleteFileRequest.FromString,
          response_serializer=google_dot_protobuf_dot_empty__pb2.Empty.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'magicleap.datasets.recordings.Recordings', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))
