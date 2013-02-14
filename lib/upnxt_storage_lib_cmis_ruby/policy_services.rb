require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class PolicyServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end
    
    def apply_policy(repository_id, policy_id, object_id, extension={})
    end

    def remove_policy(repository_id, policy_id, object_id, extension={})
    end

    def get_applied_policies(repository_id, object_id, filter, extension={})
    end
  end
end
