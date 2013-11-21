module YACCL
  class TypeService
    
    def initialize(client)
      @client = client
    end

    def create_type(repository_id, type, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createType',
                  repositoryId: repository_id,
                  type:  MultiJson.dump(type.to_hash)}
      result_hash = @client.perform_request(required)
      
      saved_children = create_descendants(repository_id, type)

      t = YACCL::Model::Type.create(result_hash)
      t.repository_id=repository_id
      t.children = saved_children
      t
    end

    def update_type(repository_id, type, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'updateType',
                  repositoryId: repository_id,
                  type: MultiJson.dump(type.to_hash)}
      result_hash = @client.perform_request(required)

      t = YACCL::Model::Type.create(result_hash)
      t.repository_id=repository_id
      t
    end

    def delete_type(repository_id, type_id, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'deleteType',
                  repositoryId: repository_id,
                  typeId: type_id}
      @client.perform_request(required)
    end

    def get_type_children(repository_id, type_id, include_property_definitions=true, max_items = nil, skip_count=nil, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeChildren',
                  repositoryId: repository_id}
      optional = {typeId: type_id,
                  includePropertyDefinitions: include_property_definitions,
                  maxItems: max_items,
                  skipCount: skip_count}
      result_hash = @client.perform_request(required, optional)

      types = []
      result_hash[:types].each do |type_hash|
        t = YACCL::Model::Type.create(type_hash)
        t.repository_id=repository_id
        types<<t
      end
      types
    end

    def get_type_descendants(repository_id, type_id, depth=nil, include_property_definitions=true, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeDescendants',
                  repositoryId: repository_id}
      optional = {typeId: type_id,
                  depth: depth,
                  includePropertyDefinitions: include_property_definitions}
      result_hash = @client.perform_request(required, optional)
      
      types = build_type_descendant_structure(repository_id, result_hash)
      types
    end

    def get_type_definition(repository_id, type_id, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'typeDefinition',
                  repositoryId: repository_id,
                  typeId: type_id}
      result = @client.perform_request(required)
      t = YACCL::Model::Type.create(result)
      t.repository_id = repository_id
      t
    end

    private
      def build_type_descendant_structure(repository_id, hash)
        types = []
        hash.each do |type_and_children_hash|
          t = YACCL::Model::Type.create(type_and_children_hash[:type])
          t.repository_id=repository_id
          t.children = build_type_descendant_structure(repository_id, type_and_children_hash[:children]) if type_and_children_hash.has_key?(:children)
          types<<t
        end
        types
      end

      def create_descendants(repository_id, type)
        children = []
        type.children.each do |t|
          # ensure that the child is actualy a child of this type
          t.parent_id = type.id if !t.parent_id or t.parent_id!=type.id
          children << create_type(repository_id, t)
        end
        children
      end

  end
end