require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class RelationshipServices
    def get_object_relationships(repository_id, object_id, include_sub_relationship_types, relationship_direction, type_id, filter, include_allowable_actions, max_items, skip_count, extension={})
      query = {
        cmisselector: 'relationships',
        objectId: object_id,
        includeSubRelationshipTypes: include_sub_relationship_types,
        relationshipDirection: relationship_direction,
        typeId: type_id,
        filter: filter,
        includeAllowableActions: include_allowable_actions,
        maxItems: max_items,
        skipCount: skip_count
      }
      BrowserBindingService.get("/#{repository_id}/root", query: query)
    end
  end
end
