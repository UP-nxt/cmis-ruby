require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class RepositoryServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def get_repository_infos(extension={})
      @service.perform_request('')
    end

    def get_repository_info(repository_id, extension={})
      params = {
        cmisselector: 'repositoryInfo'
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def get_type_children(repository_id, type_id, include_property_definitions, max_items, skip_count, extension={})
      params = {
        cmisselector: 'typeChildren',
        typeId: type_id,
        includePropertyDefinitions: include_property_definitions,
        maxItems: max_items,
        skipCount: skip_count
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def get_type_descendants(repository_id, type_id, depth, include_property_definitions, extension={})
      params = {
        cmisselector: 'typeDescendants',
        typeId: type_id,
        depth: depth,
        includePropertyDefinitions: true,
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def get_type_definition(repository_id, type_id, extension={})
      params = {
        cmisselector: 'typeDefinition',
        typeId: type_id
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def create_type(repository_id, type, extension={})
      params = {
        cmisaction: 'createType',
        type: MultiJson.dump(type)
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def update_type(repository_id, type, extension={})
      params = {
        cmisaction: 'updateType',
        type: MultiJson.dump(type)
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def delete_type(repository_id, type_id, extension={})
      params = {
        cmisaction: 'deleteType',
        typeId: type_id
      }
      @service.perform_request("/#{repository_id}", params)
    end
  end
end
