require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class MultiFilingServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def add_object_to_folder(repository_id, object_id, folder_id, all_versions, extension={})
    end

    def remove_object_from_folder(repository_id, object_id, folder_id, extension={})
    end
  end
end
