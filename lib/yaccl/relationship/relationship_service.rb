module YACCL
  class RelationshipService
    
    def initialize(client)
      @client = client
    end

    def create_relationship(repository_id, relationship, succinct = true, policies = nil, add_aces = nil, remove_aces = nil)
      required = {succinct: succinct,
                  cmisaction: 'createRelationship',
                  repositoryId: repository_id,
                  properties: relationship.to_hash}
      optional  = {policies: policies,
                   addACEs: add_aces,
                   removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)

      r = YACCL::Model::Relationship.create(result_hash[:succinctProperties])
      r.repository_id = repository_id
      r
    end

    def update_relationship(repository_id, relationship)
      object_service = @client.object_service()
      result_hash = object_service.update_object(repository_id, relationship.id, relationship.to_hash)

      relationship = YACCL::Model::Relationship.create(result_hash[:succinctProperties])
      relationship.repository_id = repository_id
      relationship
    end

    def get_relationship(repository_id, relationship_id)
      object_service = @client.object_service()
      result_hash = object_service.get_object(repository_id, relationship_id)

      relationship = YACCL::Model::Relationship.create(result_hash[:succinctProperties])
      relationship.repository_id = repository_id
      relationship
    end

    def get_object_relationships(repository_id, object_id, include_sub_relationship_types=true, relationship_direction=nil, type_id=nil, filter=nil, include_allowable_actions=nil, max_items=nil, skip_count=nil, succinct=true)
      required = {succinct: succinct,
                  cmisselector: 'relationships',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {includeSubRelationshipTypes: include_sub_relationship_types,
                  relationshipDirection: relationship_direction,
                  typeId: type_id,
                  filter: filter,
                  includeAllowableActions: include_allowable_actions,
                  maxItems: max_items,
                  skipCount: skip_count}
      result_hash = @client.perform_request(required, optional)

      relationships = []
      result_hash[:objects].each do |relationship_hash|
        r = YACCL::Model::Relationship.create(relationship_hash[:succinctProperties])
        r.repository_id = repository_id
        relationships<< r
      end
      relationships
    end

    def delete_relationship(repository_id, relationship_id)
      @client.object_service().delete_object(repository_id, relationship_id, true)
    end

  end
end