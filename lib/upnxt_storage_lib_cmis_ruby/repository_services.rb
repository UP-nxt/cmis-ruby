require 'httparty'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  class RepositoryServices
    def get_repository_infos(extension = {})
      Service.get('')
    end

    def get_repository_info(repository_id, extension = {})
      params = {
        cmisselector: 'repositoryInfo'
      }
      Service.get("/#{repository_id}", query: params)
    end

    def get_type_children(repository_id, type_id, include_property_definitions, max_items, skip_count, extension = {})
      params = {
        cmisselector: 'typeChildren',
        typeId: type_id,
        includePropertyDefinitions: include_property_definitions,
        maxItems: max_items,
        skipCount: skip_count
      }
      Service.get("/#{repository_id}", query: params)
    end

    def get_type_descendants(repository_id, type_id, depth, include_property_definitions, extension = {})
      params = {
        cmisselector: 'typeDescendants',
        typeId: type_id,
        depth: depth,
        includePropertyDefinitions: true,
      }
      Service.get("/#{repository_id}", query: params)
    end

    def get_type_definition(repository_id, type_id, extension = {})
      params = {
        cmisselector: 'typeDefinition',
        typeId: type_id
      }
      Service.get("/#{repository_id}", query: params)
    end

    def create_type(repository_id, type, extension = {})
      params = {
        cmisaction: 'createType',
        type: MultiJson.dump(type)
      }
      Service.post("/#{repository_id}", body: params)
    end

    def update_type(repository_id, type, extension = {})
      params = {
        cmisaction: 'updateType',
        type: MultiJson.dump(type)
      }
      Service.post("/#{repository_id}", body: params)
    end

    def delete_type(repository_id, type_id, extension = {})
      params = {
        cmisaction: 'deleteType',
        typeId: type_id
      }
      Service.post("/#{repository_id}", body: params)
    end
  end

  class Service
    include HTTParty
    debug_output
    base_uri 'http://localhost:8080/upncmis/browser'
    parser Proc.new { |body, format| MultiJson.load(body, symbolize_keys: true) }
  end
end


# type_json = %Q|
# {
#   "id":"my:documentType",
#   "baseId":"cmis:document",
#   "parentId":"cmis:document",
#   "displayName":"My Document Type",
#   "description":"My new type",
#   "localNamespace":"local",
#   "localName":"my:documentType",
#   "queryName":"my:documentType",
#   "fileable":true,
#   "includedInSupertypeQuery":true,
#   "creatable":true,
#   "fulltextIndexed":false,
#   "queryable":false,
#   "controllableACL":true,
#   "controllablePolicy":false,
#   "propertyDefinitions":{
#     "my:stringProperty":{
#       "id":"my:stringProperty",
#       "localNamespace":"local",
#       "localName":"my:stringProperty",
#       "queryName":"my:stringProperty",
#       "displayName":"My String Property",
#       "description":"This is a String.",
#       "propertyType":"string",
#       "updatability":"readwrite",
#       "inherited":false,
#       "openChoice":false,
#       "required":false,
#       "cardinality":"single",
#       "queryable":true,
#       "orderable":true
#     }
#   }
# }|
# 
# service = UpnxtStorageLibCmisRuby::RepositoryServices.new
# service.create_type('blueprint', MultiJson.load(type))
