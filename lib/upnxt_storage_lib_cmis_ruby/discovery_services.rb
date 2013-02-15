require_relative 'services'

module UpnxtStorageLibCmisRuby
  module Services
    class DiscoveryServices
      include Services

      def query(repository_id, statement, search_all_versions, include_relationships, rendition_filter, include_allowable_actions, max_items, skip_count, extension={})
        required = {repositoryId: repository_id,
                    cmisselector: 'query',
                    q: statement,
                    searchAllVersions: search_all_versions,
                    includeRelationships: include_relationships,
                    renditionFilter: rendition_filter,
                    includeAllowableActions: include_allowable_actions,
                    maxItems: max_items,
                    skipCount: skip_count}
        @service.perform_request(required)
      end

      def get_content_changes(repository_id, change_log_token, include_properties, include_policy_ids, include_acl, max_items, extension={})
        required = {repositoryId: repository_id,
                    cmisselector: 'contentChanges',
                    changeLogToken: change_log_token,
                    includeProperties: include_properties,
                    includePolicyIds: include_policy_ids,
                    includeAcl: include_acl,
                    maxItems: max_items}
        @service.perform_request(required)
      end
    end
  end
end
