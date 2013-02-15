require_relative 'services'

module UpnxtStorageLibCmisRuby
  module Services
    class RepositoryServices
      include Services

      def get_repositories(extension={})
        @service.perform_request
      end

      def get_repository_info(repository_id, extension={})
        required = {cmisselector: 'repositoryInfo',
                    repositoryId: repository_id}
        @service.perform_request(required)
      end

      def get_type_children(repository_id, type_id, include_property_definitions, max_items, skip_count, extension={})
        required = {cmisselector: 'typeChildren',
                    repositoryId: repository_id}
        optional = {typeId: type_id,
                    includePropertyDefinitions: include_property_definitions,
                    maxItems: max_items,
                    skipCount: skip_count}
        @service.perform_request(required, optional)
      end

      def get_type_descendants(repository_id, type_id, depth, include_property_definitions, extension={})
        required = {cmisselector: 'typeDescendants',
                    repositoryId: repository_id}
        optional = {typeId: type_id,
                    depth: depth,
                    includePropertyDefinitions: true}
        @service.perform_request(required, optional)
      end

      def get_type_definition(repository_id, type_id, extension={})
        required = {cmisselector: 'typeDefinition',
                    repositoryId: repository_id,
                    typeId: type_id}
        @service.perform_request(required)
      end

      def create_type(repository_id, type, extension={})
        required = {cmisaction: 'createType',
                    repositoryId: repository_id,
                    type: MultiJson.dump(type)}
        @service.perform_request(required)
      end

      def update_type(type, extension={})
        required = {cmisaction: 'updateType',
                    repositoryId: repository_id,
                    type: MultiJson.dump(type)}
        @service.perform_request(required)
      end

      def delete_type(repository_id, type_id, extension={})
        required = {cmisaction: 'deleteType',
                    repositoryId: repository_id,
                    typeId: type_id}
        @service.perform_request(required)
      end
    end
  end
end
