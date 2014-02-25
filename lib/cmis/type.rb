require 'active_support/core_ext/string/inflections'

module CMIS
  class Type
    attr_accessor :connection
    attr_accessor :repository

    def initialize(hash, repository)
      @repository = repository
      @connection = repository.connection if repository

      @hash = hash.with_indifferent_access

      properties = %w( id localName localNamespace queryName displayName baseId
                       parentId description creatable fileable queryable
                       controllablePolicy controllableACL fulltextIndexed
                       includedInSupertypeQuery propertyDefinitions versionable
                       contentStreamAllowed allowedSourceTypes allowedTargetTypes )

      properties.each do |key|
        class_eval "def #{key.underscore};@hash['#{key}'];end"
        class_eval "def #{key.underscore}=(value);@hash['#{key}']=value;end"
      end

      @hash['propertyDefinitions'] ||= ActiveSupport::HashWithIndifferentAccess.new
      @hash['propertyDefinitions'].each do |key, value|
        @hash['propertyDefinitions'][key] = PropertyDefinition.new(value)
      end
    end

    def add_property_definition(property)
      property_definitions[property[:id]] = property
    end

    def create
      repository.create_type(self)
    end

    def update(changed_property_defs, opts = {})
      new_defs = changed_property_defs.map(&:to_hash).reduce({}) do |result, element|
        result[element[:id]] = element
        result
      end

      hash = to_hash
      hash['propertyDefinitions'] = new_defs

      result = connection.execute!({ cmisaction: 'updateType',
                                     repositoryId: repository.id,
                                     type: MultiJson.dump(hash) }, opts)

      Type.new(result, repository)
    end

    def delete(opts = {})
      connection.execute!({ cmisaction: 'deleteType',
                            repositoryId: repository.id,
                            typeId: id }, opts)
    end

    def document_type?
      base_id == 'cmis:document'
    end

    def folder_type?
      base_id == 'cmis:folder'
    end

    def relationship_type?
      base_id == 'cmis:relationship'
    end

    def policy_type?
      base_id == 'cmis:policy'
    end

    def item_type?
      base_id == 'cmis:item'
    end

    def new_object
      object = case base_id
      when 'cmis:document'
        Document.new({}, repository)
      when 'cmis:folder'
        Folder.new({}, repository)
      when 'cmis:relationship'
        Relationship.new({}, repository)
      when 'cmis:policy'
        Policy.new({}, repository)
      when 'cmis:item'
        Item.new({}, repository)
      else
        raise "Unsupported base type: #{base_id}"
      end
      object.object_type_id = id
      object
    end

    def to_hash
      @hash
    end
  end
end
