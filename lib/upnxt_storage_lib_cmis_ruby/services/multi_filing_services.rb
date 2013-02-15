require_relative 'services'

module UpnxtStorageLibCmisRuby
  module Services
    class MultiFilingServices
      include Services

      def add_object_to_folder(repository_id, object_id, folder_id, all_versions, extension={})
        required = {repositoryId: repository_id,
                    cmisaction: 'addObjectToFolder',
                    objectId: object_id,
                    folderId: folder_id,
                    allVersions: all_versions}
        @service.perform_request(required)
      end

      def remove_object_from_folder(repository_id, object_id, folder_id, extension={})
        required = {repositoryId: repository_id,
                    cmisaction: 'removeObjectFromFolder',
                    objectId: object_id,
                    folderId: folder_id}
        @service.perform_request(required)
      end
    end
  end
end
