require_relative 'services'
module Model
    class Folder < Object
        def self.create(raw)
            Folder.new(raw)
        end

        attr_reader :parent_id
        attr_reader :path
        attr_reader :allowed_child_object_type_ids

        def initialize(raw)
            super(raw)
            @parent_id = raw[:'cmis:parentId']
            @path = raw[:'cmis:path']
            @allowed_child_object_type_ids = raw[:'cmis:allowedChildObjectTypeIds']
        end

        def parent
            repository.object(parent_id)
        end

        def allowed_child_object_types
            return nil if allowed_child_object_type_ids.nil?
            allowed_child_object_type_ids.map do |type_id|
                repository.type(type_id)
            end
        end

        def children
            Services.navigation.get_children(repository_id, object_id, nil, nil, nil, nil, nil, nil, nil, nil).map do |o|
                Object.create(o)
            end
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
end