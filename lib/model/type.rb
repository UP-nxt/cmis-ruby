module Model
    class Type
        def self.create(raw)
            Type.new(raw)
        end

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
        attr_accessor :fulletext_indexed
        attr_accessor :include_in_supertype_query
        attr_accessor :property_definitions

        def initialize(hash = {})
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
            @fulletext_indexed = hash[:fulletextIndexed]
            @include_in_supertype_query = hash[:includeInSupertype_query]
            @property_definitions = hash[:propertyDefinitions] || {}
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
            hash[:fulletextIndexed]= fulletext_indexed
            hash[:includeInSupertype_query]= include_in_supertype_query
            hash[:propertyDefinitions]= property_definitions
            hash
        end
    end
end