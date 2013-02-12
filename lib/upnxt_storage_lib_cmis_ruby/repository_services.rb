require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class RepositoryServices
    def get_repository_infos(extension={})
      BrowserBindingService.get('')
    end

    def get_repository_info(repository_id, extension={})
      params = {
        cmisselector: 'repositoryInfo'
      }
      BrowserBindingService.get("/#{repository_id}", query: params)
    end

    def get_type_children(repository_id, type_id, include_property_definitions, max_items, skip_count, extension={})
      params = {
        cmisselector: 'typeChildren',
        typeId: type_id,
        includePropertyDefinitions: include_property_definitions,
        maxItems: max_items,
        skipCount: skip_count
      }
      BrowserBindingService.get("/#{repository_id}", query: params)
    end

    def get_type_descendants(repository_id, type_id, depth, include_property_definitions, extension={})
      params = {
        cmisselector: 'typeDescendants',
        typeId: type_id,
        depth: depth,
        includePropertyDefinitions: true,
      }
      BrowserBindingService.get("/#{repository_id}", query: params)
    end

    def get_type_definition(repository_id, type_id, extension={})
      params = {
        cmisselector: 'typeDefinition',
        typeId: type_id
      }
      BrowserBindingService.get("/#{repository_id}", query: params)
    end

    def create_type(repository_id, type, extension={})
      params = {
        cmisaction: 'createType',
        type: MultiJson.dump(type)
      }
      BrowserBindingService.post("/#{repository_id}", body: params)
    end

    def update_type(repository_id, type, extension={})
      params = {
        cmisaction: 'updateType',
        type: MultiJson.dump(type)
      }
      BrowserBindingService.post("/#{repository_id}", body: params)
    end

    def delete_type(repository_id, type_id, extension={})
      params = {
        cmisaction: 'deleteType',
        typeId: type_id
      }
      BrowserBindingService.post("/#{repository_id}", body: params)
    end
  end
end
