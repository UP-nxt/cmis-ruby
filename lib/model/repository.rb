require_relative 'services'
require_relative 'object'
require_relative 'type'

module Model
  class Repository
    def self.create(raw_repository)
      Repository.new(raw_repository)
    end

    def initialize(raw)
      @id = raw[:repositoryId]
      @name = raw[:repositoryName]
      @description = raw[:repositoryDescription]
      @raw = raw
    end

    attr_reader :id
    attr_reader :name
    attr_reader :description

    def root_folder_id
      @raw[:rootFolderId]
    end

    def root
      Object.create(Services.object.get_object(id, root_folder_id, nil, false, false, nil, false, false))
    end

    def object(object_id)
      Object.create(Services.object.get_object(id, object_id, nil, false, false, nil, false, false))
    end

    def type(type_id)
      Type.create(Services.repository.get_type_definition(id, type_id))
    end

    def type_tree

    end

    def create_type(type)
      Type.create(Services.repository.create_type(id, type.to_hash))
    end

    def update_type(type)
      Type.create(Services.repository.update_type(id, type.to_hash))
    end

    def delete_type(type_id)
      Services.repository.delete_type(id, type_id)
    end
  end
end