module YACCL
  module PolicyServices
    def apply_policy(repository_id, policy_id, object_id, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'applyPolicy',
                  repositoryId: repository_id,
                  policyId: policy_id,
                  objectId: object_id}
      perform_request(required)
    end

    def remove_policy(repository_id, policy_id, object_id, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'removePolicy',
                  repositoryId: repository_id,
                  policyId: policy_id,
                  objectId: object_id}
      perform_request(required)
    end

    def get_applied_policies(repository_id, object_id, filter, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'policies',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {filter: filter}
      perform_request(required, optional)
    end
  end
end
