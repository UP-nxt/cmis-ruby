require_relative 'object'
require_relative 'services'

module Model
  class Folder < Object
    attr_reader :parent_id
    attr_reader :path
    attr_reader :allowed_child_object_type_ids

    def initialize(repository_id, raw = {})
      super(repository_id, raw)
      properties = raw[:properties]
      @parent_id = get_property_value(properties, :'cmis:parentId')
      @path = get_property_value(properties, :'cmis:path')
      @allowed_child_object_type_ids = get_property_value(properties, :'cmis:allowedChildObjectTypeIds')
    end

    def parent
      repository.object(parent_id) unless parent_id.nil?
    end

    def allowed_child_object_types
      return nil if allowed_child_object_type_ids.nil?
      allowed_child_object_type_ids.map do |type_id|
        repository.type(type_id)
      end
    end

    def children
      Services.navigation.get_children(repository_id, object_id, nil, nil, nil, nil, nil, nil, nil, nil).map do |o|
        ObjectFactory.create(repository_id, o)
      end
    end

    def tree(depth)

    end

    def create(object)
      properties = object.create_properties
      if object.is_a? Folder
        o = Services.object.create_folder(repository_id, properties, object_id, nil, nil, nil)
      elsif object.is_a? Document
        return object.create_in_folder(object_id)
      elsif object.is_a? Relationship
        raise 'relationship is not fileable'
      elsif object.is_a? Policy
        o = Services.object.create_policy(repository_id, properties, object_id, nil, nil, nil)
      elsif object.is_a? Item
        o = Services.object.create_item(repository_id, properties, object_id, nil, nil, nil)
      else
        raise "unexpected base_type_id #{object.base_type_id}"
      end
      ObjectFactory.create(repository_id, o)
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