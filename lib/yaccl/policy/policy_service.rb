module YACCL
  class PolicyService
    def initialize(client)
      @client=client
    end

    def create_policy(repository_id, policy, succinct = true, folder_id = nil, policies = nil, add_aces=nil, remove_aces=nil)
      required = {succinct: succinct,
                  cmisaction: 'createPolicy',
                  repositoryId: repository_id,
                  properties: policy.to_hash}
      optional = {objectId: folder_id,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)
      
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_policy(repository_id, policy_id)
      object_service = @client.object_service()
      result_hash = object_service.get_object(repository_id, policy_id)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def update_policy(repository_id, policy)
      result_hash = @client.object_service().update_object(repository_id, policy.id, policy.to_hash, policy.change_token)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def apply_policy(repository_id, policy_id, object_id, succinct = true)
      required = {succinct: succinct,
                  cmisaction: 'applyPolicy',
                  repositoryId: repository_id,
                  policyId: policy_id,
                  objectId: object_id}
      result_hash = @client.perform_request(required)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def remove_policy(repository_id, policy_id, object_id, succinct=true)
      required = {succinct: succinct,
                  cmisaction: 'removePolicy',
                  repositoryId: repository_id,
                  policyId: policy_id,
                  objectId: object_id}
      result_hash = @client.perform_request(required)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def delete_policy(repository_id, policy_id)
      @client.object_service().delete_object(repository_id, policy_id, true)
    end

  end
end