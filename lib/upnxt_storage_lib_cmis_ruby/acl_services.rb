require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class AclServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def get_acl(repository_id, object_id, only_basic_permissions, extension={})
    end

    def apply_acl(repository_id, object_id, add_aces, remove_aces, acl_propagation, extension={})
    end
  end
end
