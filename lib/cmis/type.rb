require 'core_ext/hash/keys'
require 'core_ext/string/as_ruby_property'
require 'json'

module CMIS
  class Type
    attr_accessor :repository

    def initialize(hash, repository)
      @repository = repository
      @hash = hash.deep_stringify_keys

      properties = %w( id localName localNamespace queryName displayName baseId
                       parentId description creatable fileable queryable
                       controllablePolicy controllableACL fulltextIndexed
                       includedInSupertypeQuery propertyDefinitions versionable
                       contentStreamAllowed allowedSourceTypes allowedTargetTypes )

      properties.each do |key|
        self.class.class_eval "def #{key.as_ruby_property};@hash['#{key}'];end"
        self.class.class_eval "def #{key.as_ruby_property}=(value);@hash['#{key}']=value;end"
      end

      @hash['propertyDefinitions'] ||= {}
      @hash['propertyDefinitions'].each do |key, value|
        @hash['propertyDefinitions'][key] = PropertyDefinition.new(value)
      end
    end

    def add_property_definition(property)
      property.stringify_keys!
      property_definitions[property['id']] = property
    end

    def create
      repository.create_type(self)
    end

    def update(changed_property_defs, opts = {})
      changed_property_defs.map!(&:deep_stringify_keys)

      new_defs = changed_property_defs.map(&:to_hash).reduce({}) do |result, element|
        result[element['id']] = element
        result
      end

      hash = to_hash
      hash['propertyDefinitions'] = new_defs

      result = server.execute!({ cmisaction: 'updateType',
                                 repositoryId: repository.id,
                                 type: JSON.generate(hash) }, opts)

      Type.new(result, repository)
    end

    def delete(opts = {})
      server.execute!({ cmisaction: 'deleteType',
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

    private

    def server
      repository.server if repository
    end
  end
end
