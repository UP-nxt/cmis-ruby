require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class DiscoveryServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def query(repository_id, statement, search_all_versions, include_relationships, rendition_filter, include_allowable_actions, max_items, skip_count, extension={})
      params = {
        cmisselector: 'query',
        q: statement,
        searchAllVersions: search_all_versions,
        includeRelationships: include_relationships,
        renditionFilter: rendition_filter,
        includeAllowableActions: include_allowable_actions,
        maxItems: max_items,
        skipCount: skip_count
      }
      @service.perform_request("/#{repository_id}", params)
    end


    def get_content_changes(repository_id, change_log_token, include_properties, include_policy_ids, include_acl, max_items, extension={})
      params = {
        cmisselector: 'contentChanges',
        changeLogToken: change_log_token,
        includeProperties: include_properties,
        includePolicyIds: include_policy_ids,
        includeAcl: include_acl,
        maxItems: max_items
      }
      @service.perform_request("/#{repository_id}", params)
    end
  end
end
