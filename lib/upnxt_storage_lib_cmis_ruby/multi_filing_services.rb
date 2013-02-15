require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class MultiFilingServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def add_object_to_folder(repository_id, object_id, folder_id, all_versions, extension={})
      required = { repositoryId: repository_id,
                   cmisaction: 'addObjectToFolder',
                   objectId: object_id,
                   folderId: folder_id,
                   allVersions: all_versions }
      @service.perform_request(required)
    end

    def remove_object_from_folder(repository_id, object_id, folder_id, extension={})
      required = { repositoryId: repository_id,
                   cmisaction: 'removeObjectFromFolder',
                   objectId: object_id,
                   folderId: folder_id }
      @service.perform_request(required)
    end
  end
end
