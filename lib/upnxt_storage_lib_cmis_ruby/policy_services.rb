require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class PolicyServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def apply_policy(repository_id, policy_id, object_id, extension={})
      required = {repositoryId: repository_id,
                  cmisaction: 'applyPolicy',
                  policyId: policy_id,
                  objectId: object_id}
      @service.perform_request(required)
    end

    def remove_policy(repository_id, policy_id, object_id, extension={})
      required = {repositoryId: repository_id,
                  cmisaction: 'removePolicy',
                  policyId: policy_id,
                  objectId: object_id}
      @service.perform_request(required)
    end

    def get_applied_policies(repository_id, object_id, filter, extension={})
      required = {repositoryId: repository_id,
                  cmisselector: 'policies',
                  objectId: object_id,
                  filter: filter}
      @service.perform_request(required)
    end
  end
end
