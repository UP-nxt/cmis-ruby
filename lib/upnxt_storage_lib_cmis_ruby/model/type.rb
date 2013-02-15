module UpnxtStorageLibCmisRuby
  module Model
    class Type
      attr_accessor :id
      attr_accessor :local_name
      attr_accessor :local_namespace
      attr_accessor :query_name
      attr_accessor :display_name
      attr_accessor :base_id
      attr_accessor :parent_id
      attr_accessor :description
      attr_accessor :creatable
      attr_accessor :fileable
      attr_accessor :queryable
      attr_accessor :controllable_policy
      attr_accessor :controllable_acl
      attr_accessor :fulltext_indexed
      attr_accessor :included_in_supertype_query
      attr_accessor :property_definitions
      # document type
      attr_accessor :versionable
      attr_accessor :content_stream_allowed
      # relationship type
      attr_accessor :allowed_source_types
      attr_accessor :allowed_target_types

      def self.create(raw)
        Type.new(raw)
      end

      def initialize(hash={})
        @id = hash[:id]
        @local_name = hash[:localName]
        @local_namespace = hash[:localNamespace]
        @query_name = hash[:queryName]
        @display_name = hash[:displayName]
        @base_id = hash[:baseId]
        @parent_id = hash[:parentId]
        @description = hash[:description]
        @creatable = hash[:creatable]
        @fileable = hash[:fileable]
        @queryable = hash[:queryable]
        @controllable_policy = hash[:controllablePolicy]
        @controllable_acl = hash[:controllableACL]
        @fulltext_indexed = hash[:fulltextIndexed]
        @included_in_supertype_query = hash[:includedInSupertype_query]
        @property_definitions = hash[:propertyDefinitions] || {}
        # document type
        @versionable = hash[:versionable]
        @content_stream_allowed = hash[:contentStreamAllowed]
        # relationship type
        @allowed_source_types = hash[:allowedSourceTypes]
        @allowed_target_types = hash[:allowedTargetTypes]
      end

      def add_property_definition(property)
        @property_definitions[property[:id]] = property
      end

      def to_hash
        hash = {}
        hash[:id] = id
        hash[:localName] = local_name
        hash[:localNamespace] = local_namespace
        hash[:queryName]= query_name
        hash[:displayName]= display_name
        hash[:baseId]= base_id
        hash[:parentId]= parent_id
        hash[:description]= description
        hash[:creatable]= creatable
        hash[:fileable]= fileable
        hash[:queryable]= queryable
        hash[:controllablePolicy]= controllable_policy
        hash[:controllableACL]= controllable_acl
        hash[:fulltextIndexed]= fulltext_indexed
        hash[:includedInSupertypeQuery]= included_in_supertype_query
        hash[:propertyDefinitions]= property_definitions
        # document type
        hash[:versionable] = versionable unless versionable.nil?
        hash[:contentStreamAllowed] = content_stream_allowed unless content_stream_allowed.nil?
        # relationship type
        hash[:allowedSourceTypes] = allowed_source_types unless allowed_source_types.nil?
        hash[:allowedTargetTypes] = allowed_target_types unless allowed_target_types.nil?
        hash
      end
    end
  end
end
