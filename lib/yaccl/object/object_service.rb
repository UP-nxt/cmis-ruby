module YACCL
  class ObjectService
    
    def initialize(client)
      @client = client
    end

    def update_object(repository_id, object_id, properties, change_token = 1, succinct = false)
      required = {succinct: succinct,
                  cmisaction: 'update',
                  repositoryId: repository_id,
                  objectId: object_id,
                  properties: properties}
      optional = {changeToken: change_token}
      @client.perform_request(required, optional)
    end

    def get_object(repository_id, object_id, succinct=false, filter=nil, include_allowable_actions=true, include_relationships=:both, rendition_filter=nil, include_policy_ids=true, include_acl=true)
      required = {succinct: succinct,
                  cmisselector: 'object',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {filter: filter,
                  includeAllowableActions: include_allowable_actions,
                  includeRelationships: include_relationships,
                  renditionFilter: rendition_filter,
                  includePolicyIds: include_policy_ids,
                  includeAcl: include_acl}
      @client.perform_request(required, optional)
    end

    def delete_object(repository_id, object_id, all_versions, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'delete',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {allVersions: all_versions}
      @client.perform_request(required, optional)
    end

  end
end