require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class PolicyServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def apply_policy(repository_id, policy_id, object_id, extension={})
      params = {
        cmisaction: 'applyPolicy',
        policyId: policy_id,
        objectId: object_id
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def remove_policy(repository_id, policy_id, object_id, extension={})
      params = {
        cmisaction: 'removePolicy',
        policyId: policy_id,
        objectId: object_id
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def get_applied_policies(repository_id, object_id, filter, extension={})
      params = {
        cmisselector: 'policies',
        objectId: object_id,
        filter: filter
      }
      @service.perform_request("/#{repository_id}/root", params)
    end
  end
end
