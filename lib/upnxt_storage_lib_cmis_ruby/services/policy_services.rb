module UpnxtStorageLibCmisRuby
  module Services
    class PolicyServices
      def initialize(service_url)
        @service = Internal::BrowserBindingService.new(service_url)
      end

      def apply_policy(repository_id, policy_id, object_id, extension={})
        required = {cmisaction: 'applyPolicy',
                    repositoryId: repository_id,
                    policyId: policy_id,
                    objectId: object_id}
        @service.perform_request(required)
      end

      def remove_policy(repository_id, policy_id, object_id, extension={})
        required = {cmisaction: 'removePolicy',
                    repositoryId: repository_id,
                    policyId: policy_id,
                    objectId: object_id}
        @service.perform_request(required)
      end

      def get_applied_policies(repository_id, object_id, filter, extension={})
        required = {cmisselector: 'policies',
                    repositoryId: repository_id,
                    objectId: object_id}
        optional = {filter: filter}
        @service.perform_request(required, optional)
      end
    end
  end
end
