module YACCL
  module Model
    class Folder < Object
      attr_reader :parent_id
      attr_reader :path
      attr_reader :allowed_child_object_type_ids

      def initialize(repository_id, raw={})
        super
        @parent_id = @properties[:'cmis:parentId']
        @path = @properties[:'cmis:path']
        @allowed_child_object_type_ids = @properties[:'cmis:allowedChildObjectTypeIds']
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

      def children(options={})
        children = Services.get_children(repository_id, cmis_object_id, options[:filter], options[:order_by], options[:include_allowable_actions], options[:include_relations], options[:rendition_filter], options[:include_path_segment], options[:max_items], options[:skip_count])
        if children[:objects]
          children[:objects].map! { |o| ObjectFactory.create(repository_id, o[:object]) }
        else
          children[:objects] = []
        end
        children[:num_items] = children.delete(:numItems).to_i
        children[:has_more_items] = children.delete(:hasMoreItems)

        yield(children) if block_given?
        children[:objects]
      end

      def tree(depth)
      end

      def create(object)
        properties = object.create_properties
        if object.is_a? Folder
          o = Services.create_folder(repository_id, properties, cmis_object_id, nil, nil, nil)
        elsif object.is_a? Document
          return object.create_in_folder(cmis_object_id)
        elsif object.is_a? Relationship
          raise 'relationship is not fileable'
        elsif object.is_a? Policy
          o = Services.create_policy(repository_id, properties, cmis_object_id, nil, nil, nil)
        elsif object.is_a? Item
          o = Services.create_item(repository_id, properties, cmis_object_id, nil, nil, nil)
        else
          raise "Unexpected base_type_id: #{object.base_type_id}"
        end
        ObjectFactory.create(repository_id, o)
      end

      def delete_tree
        Services.delete_tree(repository_id, cmis_object_id, nil, nil, nil)
      end

      def add(object)
        Services.add_object_to_folder(repository_id, object.cmis_object_id, cmis_object_id, nil)
      end

      def remove(object)
        Services.remove_object_from_folder(repository_id, object.cmis_object_id, cmis_object_id)
      end
    end
  end
end
