module YACCL
  module RepositoryServices
    def get_repositories
      perform_request
    end

    def get_repository_info(repository_id, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'repositoryInfo',
                  repositoryId: repository_id}
      perform_request(required)
    end

    def get_type_children(repository_id, type_id, include_property_definitions, max_items, skip_count, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeChildren',
                  repositoryId: repository_id}
      optional = {typeId: type_id,
                  includePropertyDefinitions: include_property_definitions,
                  maxItems: max_items,
                  skipCount: skip_count}
      perform_request(required, optional)
    end

    def get_type_descendants(repository_id, type_id, depth, include_property_definitions, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeDescendants',
                  repositoryId: repository_id}
      optional = {typeId: type_id,
                  depth: depth,
                  includePropertyDefinitions: include_property_definitions}
      perform_request(required, optional)
    end

    def get_type_definition(repository_id, type_id, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeDefinition',
                  repositoryId: repository_id,
                  typeId: type_id}
      perform_request(required)
    end

    def create_type(repository_id, type, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createType',
                  repositoryId: repository_id,
                  type: MultiJson.dump(type)}
      perform_request(required)
    end

    def update_type(type, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'updateType',
                  repositoryId: repository_id,
                  type: MultiJson.dump(type)}
      perform_request(required)
    end

    def delete_type(repository_id, type_id, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'deleteType',
                  repositoryId: repository_id,
                  typeId: type_id}
      perform_request(required)
    end
  end
end
