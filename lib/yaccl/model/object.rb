module YACCL
  module Model
    class Object
      attr_reader :repository_id
      attr_reader :cmis_object_id
      attr_reader :base_type_id
      attr_accessor :object_type_id
      attr_reader :secondary_object_type_ids
      attr_accessor :name
      attr_reader :description
      attr_reader :created_by
      attr_reader :creation_date
      attr_reader :last_modified_by
      attr_reader :last_modification_date
      attr_accessor :change_token
      attr_accessor :properties

      def object_id
        warn "[DEPRECATION] using `object_id` for CMIS objects is deprecated.  Please use `cmis_object_id` instead."
        cmis_object_id
      end

      def initialize(repository_id, raw={})
        @repository_id = repository_id
        @properties = get_properties_map(raw)

        @cmis_object_id = @properties[:'cmis:objectId']
        @base_type_id = @properties[:'cmis:baseTypeId']
        @object_type_id = @properties[:'cmis:objectTypeId']
        @secondary_object_type_ids = @properties[:'cmis:secondaryObjectTypeIds']
        @name = @properties[:'cmis:name']
        @description = @properties[:'cmis:description']
        @created_by = @properties[:'cmis:createdBy']
        @creation_date = @properties[:'cmis:creationDate']
        @last_modified_by = @properties[:'cmis:lastModifiedBy']
        @last_modification_date = @properties[:'cmis:lastModificationDate']
        @change_token = @properties[:'cmis:changeToken']
      end

      def repository
        Server.repository(repository_id)
      end

      def object_type
        repository.type(object_type_id)
      end

      def delete
        Services.delete_object(repository_id, cmis_object_id, true)
      end

      def update_properties(properties)
        r = Services.update_properties(repository_id, cmis_object_id, change_token, properties)
        update_change_token(r)
      end

      def parents
        Services.get_object_parents(repository_id, cmis_object_id, nil, nil, nil, nil, nil).map do |o|
          ObjectFactory.create(repository_id, o[:object])
        end
      end

      def allowable_actions
        Services.get_allowable_actions(repository_id, cmis_object_id)
      end

      def relationships(direction=:either)
        result = Services.get_object_relationships(repository_id, cmis_object_id, nil, direction, nil, nil, false, nil, nil)
        result[:objects].map { |r| Relationship.new(repository_id, r) }
      end

      def policies
        Services.get_applied_policies(repository_id, cmis_object_id, nil).map do |policy|
          Policy.new(repository_id, policy)
        end
      end

      # remove from all folders
      def unfile
        Services.remove_object_from_folder(repository_id, cmis_object_id, nil)
      end

      def move(target_folder)
        object_parents = parents
        if object_parents.size == 1
          Services.move_object(repository_id, cmis_object_id, target_folder.cmis_object_id, object_parents.first.cmis_object_id)
        else
          # raise?
        end
      end

      def acls
        Services.get_acl(repository_id, cmis_object_id, nil)
      end

      def add_aces(aces)
        Services.apply_acl(repository_id, cmis_object_id, aces, nil, nil)
      end

      def remove_aces(aces)
        Services.apply_acl(repository_id, cmis_object_id, nil, aces, nil)
      end

      def create_properties
        {'cmis:name' => name, 'cmis:objectTypeId' => object_type_id}.merge(properties)
      end

      def detached?
        cmis_object_id.nil?
      end

      # utility

      def can_be_deleted?
        allowable_actions[:canDeleteObject]
      end

      def can_get_parents?
        allowable_actions[:canGetObjectParents]
      end

      def can_update_properties
        allowable_actions[:canUpdateProperties]
      end

      def method_missing(method_sym, *arguments, &block)
        @properties[method_sym] ? @properties[method_sym] : super
      end

      def update_change_token(r)
        @change_token = if r[:properties]
          r[:properties][:'cmis:changeToken'][:value]
        elsif r[:succinctProperties]
          r[:succinctProperties][:'cmis:changeToken']
        else
          raise "Unexpected response: #{r}"
        end
      end

      private

      def get_properties_map(raw)
        if raw[:succinctProperties]
          result = raw[:succinctProperties]
        elsif raw[:properties]
          result = raw[:properties].reduce({}) do |h, (k, v)|
            val = v[:value]
            val = v[:value].first if v[:value].is_a?(Array) and v[:type] == 'datetime'
            val = Time.at(val / 1000) if val and v[:type] == 'datetime'
            h.merge(k => val)
          end
        else
          result = {}
        end
        result
      end
    end
  end
end
