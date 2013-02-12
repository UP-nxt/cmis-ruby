require_relative 'services'

class Folder < Object
    def self.create(raw)
        Folder.new(raw)
    end

    attr_reader :parent_id
    attr_reader :path
    attr_reader :allowed_child_object_type_ids

    def initialize(raw)
        @raw = raw
    end

    def parent

    end

    def allowed_child_object_types

    end

    def children

    end

    def tree(depth)

    end

    def create(object)

    end

    def delete_tree
        Services.object.delete_tree(repository_id, object_id, true, false, false)
    end

    def add(object)
        Services.multi_filing.add_object_to_folder(repository_id, object.object_id, object_id, nil)
    end

    def remove(object)
        Services.multi_filing.remove_object_from_folder(repository_id, object.object_id, object_id)
    end
end