require_relative 'server'
require_relative 'services'

module Model
  class Object

    def initialize(repository_id, raw = {})
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

    def repository
      Server.repository(repository_id)
    end

    def object_type
      repository.type(object_type_id)
    end

    def delete
      Services.object.delete_object(repository_id, object_id, true)
    end

    def allowable_actions
      Services.object.get_allowable_actions(repository_id, object_id)
    end

    def relationships(direction)
      Services.relationship.get_object_relationships(repository_id, object_id, nil, direction, nil, nil, false, nil, nil).map do |r|
        Relationship.create(repository_id, r)
      end
    end

    def policies
      Services.policy.get_applied_policies(repository_id, object_id, nil).map do |policy|
        Policy.create(repository_id, policy)
      end
    end

    # remove from all folders
    def unfile
      Services.multi_filing.remove_object_from_folder(repository_id, object_id, nil)
    end


    def acls
      Services.acl.get_acl(repository_id, object_id, nil)
    end

    def add_aces(aces)
      Services.acl.apply_acl(repository_id, object_id, aces, nil, nil)
    end

    def remove_aces(aces)
      Services.acl.apply_acl(repository_id, object_id, nil, aces, nil)
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
      result = {}
      raw_properties.each do |k, v|
        result[k] = v[:value]
      end
      result
    end
  end
end