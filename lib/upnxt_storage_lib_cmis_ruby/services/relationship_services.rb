module UpnxtStorageLibCmisRuby
  module Services
    class RelationshipServices
      def initialize(service_url)
        @service = Internal::BrowserBindingService.new(service_url)
      end

      def get_object_relationships(repository_id, object_id, include_sub_relationship_types, relationship_direction, type_id, filter, include_allowable_actions, max_items, skip_count, extension={})
        required = {cmisselector: 'relationships',
                    repositoryId: repository_id,
                    objectId: object_id}
        optional = {includeSubRelationshipTypes: include_sub_relationship_types,
                    relationshipDirection: relationship_direction,
                    typeId: type_id,
                    filter: filter,
                    includeAllowableActions: include_allowable_actions,
                    maxItems: max_items,
                    skipCount: skip_count}
        @service.perform_request(required, optional)
      end
    end
  end
end
