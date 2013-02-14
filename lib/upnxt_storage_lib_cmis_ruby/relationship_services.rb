require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class RelationshipServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def get_object_relationships(repository_id, object_id, include_sub_relationship_types, relationship_direction, type_id, filter, include_allowable_actions, max_items, skip_count, extension={})
      params = {
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
      @service.perform_request("/#{repository_id}/root", params)
    end
  end
end
