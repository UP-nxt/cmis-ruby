module UpnxtStorageLibCmisRuby
  module Model
    class Object
      attr_reader :repository_id
      attr_reader :object_id
      attr_reader :base_type_id
      attr_accessor :object_type_id
      attr_reader :secondary_object_type_ids
      attr_accessor :name
      attr_reader :description
      attr_reader :created_by
      attr_reader :creation_date
      attr_reader :last_modified_by
      attr_reader :last_modification_date
      attr_reader :change_token
      attr_reader :properties

      def initialize(repository_id, raw={})
        @repository_id = repository_id
        @properties = get_properties_map(raw)
        @object_id = @properties[:'cmis:objectId']
        @base_type_id = @properties[:'cmis:baseTypeId']
        @object_type_id = @properties[:'cmis:objectTypeId']
        @secondary_object_type_ids = @properties[:'cmis:secondaryObjectTypeId']
        @name = @properties[:'cmis:name']
        @description = @properties[:'cmis:description']
        @created_by = @properties[:'cmis:createdBy']
        @creation_date = @properties[:'cmis:creationDate']
        @last_modified_by = @properties[:'cmis:lastModifiedBy']
        @last_modification_date = @properties[:'cmis:lastModificationDate']
        @change_token = @properties[:'cmis:changeToken']
      end

      def repository
        Service.repository(repository_id)
      end

      def object_type
        repository.type(object_type_id)
      end

      def delete
        UpnxtStorageLibCmisRuby::Services.object.delete_object(repository_id, object_id, true)
      end

      def allowable_actions
        UpnxtStorageLibCmisRuby::Services.object.get_allowable_actions(repository_id, object_id)
      end

      def relationships(direction = 'either')
        result = UpnxtStorageLibCmisRuby::Services.relationship.get_object_relationships(repository_id, object_id, nil, direction, nil, nil, false, nil, nil)
        result[:objects] = result[:objects].map do |r|
          Relationship.create(repository_id, r)
        end
        result
      end

      def policies
        UpnxtStorageLibCmisRuby::Services.policy.get_applied_policies(repository_id, object_id, nil).map do |policy|
          Policy.create(repository_id, policy)
        end
      end

      # remove from all folders
      def unfile
        UpnxtStorageLibCmisRuby::Services.multi_filing.remove_object_from_folder(repository_id, object_id, nil)
      end


      def acls
        UpnxtStorageLibCmisRuby::Services.acl.get_acl(repository_id, object_id, nil)
      end

      def add_aces(aces)
        UpnxtStorageLibCmisRuby::Services.acl.apply_acl(repository_id, object_id, aces, nil, nil)
      end

      def remove_aces(aces)
        UpnxtStorageLibCmisRuby::Services.acl.apply_acl(repository_id, object_id, nil, aces, nil)
      end

      protected

      def create_properties
        props = {'cmis:name' => name, 'cmis:objectTypeId' => object_type_id}
        props.merge(properties)
      end

      def detached?
        object_id.nil?
      end

      private

      def get_properties_map(raw)
        raw_properties = raw[:properties]
        return {} if raw_properties.nil?
        raw_properties.reduce({}) { |h, (k, v)| h.merge(k => v[:value]) }
      end
    end
  end
end
