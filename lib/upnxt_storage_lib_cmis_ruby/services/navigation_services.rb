module UpnxtStorageLibCmisRuby
  module Services
    class NavigationServices
      def initialize(service_url)
        @service = Internal::BrowserBindingService.new(service_url)
      end

      def get_children(repository_id, folder_id, filter, order_by, include_allowable_actions, include_relationships, rendition_filter, include_path_segment, max_items, skip_count, extension={})
        required = {cmisselector: 'children',
                    repositoryId: repository_id,
                    objectId: folder_id}
        optional = {filter: filter,
                    orderBy: order_by,
                    includeAllowableActions: include_allowable_actions,
                    includeRelationships: include_relationships,
                    renditionFilter: rendition_filter,
                    includePathSegment: include_path_segment,
                    maxItems: max_items,
                    skipCount: skip_count}
        @service.perform_request(required, optional)
      end

      def get_descendants(repository_id, folder_id, depth, filter, include_allowable_actions, include_relationships, rendition_filter, include_path_segment, extension={})
        required = {cmisselector: 'descendants',
                    repositoryId: repository_id,
                    objectId: folder_id}
        optional = {depth: depth,
                    filter: filter,
                    includeAllowableActions: include_allowable_actions,
                    includeRelationships: include_relationships,
                    renditionFilter: rendition_filter,
                    includePathSegment: include_path_segment}
        @service.perform_request(required, optional)
      end

      def get_folder_tree(repository_id, folder_id, depth, filter, include_allowable_actions, include_relationships, rendition_filter, include_path_segment, extension={})
        required = {cmisselector: 'folderTree',
                    repositoryId: repository_id,
                    objectId: folder_id}
        optional = {depth: depth,
                    filter: filter,
                    includeAllowableActions: include_allowable_actions,
                    includeRelationships: include_relationships,
                    renditionFilter: rendition_filter,
                    includePathSegment: include_path_segment}
        @service.perform_request(required, optional)
      end

      def get_folder_parent(repository_id, folder_id, filter, extension={})
        required = {cmisselector: 'parent',
                    repositoryId: repository_id,
                    objectId: folder_id}
        optional = {filter:filter}
        @service.perform_request(required, optional)
      end

      def get_object_parents(repository_id, object_id, filter, include_allowable_actions, include_relationships, rendition_filter, include_relative_path_segment, extension={})
        required = {cmisselector: 'parents',
                    repositoryId: repository_id,
                    objectId: object_id}
        optional = {filter: filter,
                    includeAllowableActions: include_allowable_actions,
                    includeRelationships: include_relationships,
                    renditionFilter: rendition_filter,
                    includePathSegment: include_path_segment}
        @service.perform_request(required, optional)
      end

      def get_checked_out_docs(repository_id, folder_id, filter, order_by, include_allowable_actions, include_relationships, rendition_filter, max_items, skip_count, extension={})
        required = {cmisselector: 'checkedout',
                    repositoryId: repository_id}
        optional =  {objectId: folder_id,
                     filter: filter,
                     orderBy: order_by,
                     includeAllowableActions: include_allowable_actions,
                     includeRelationships: include_relationships,
                     renditionFilter: rendition_filter,
                     maxItems: max_items,
                     skipCount: skip_count}
        @service.perform_request(required, optional)
      end
    end
  end
end
