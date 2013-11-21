module YACCL
  module Model
    class Type
      @@property_map = {}
      # CMIS returns, in some cases, properties with different names. 
      # For example:
      # In case of repository: instead of "cmis:id" we get "repositoryId"
      # this method is mapping the input from CMIS with our properties. we prepare them directly for CMIS 
      def self.property_map(data = {input: nil, property: nil})
        @@property_map[data[:input]] = data[:property]
      end

      # Creates accessor with "method_name" for @property[property_name]
      # This is done only to access the data easier. 
      # For example:
      # defining ` property_attr_accessor :base_type_id, :'cmis:baseTypeId' ` in our Object class we can
      # instead of doing `folder[:'cmis:baseTypeTypeId']` we will just do `folder.base_type_id`
      def self.property_attr_accessor(method_name, property_name = method_name)
        class_eval <<-EVALCODE
          def #{method_name}
            @properties[:'#{property_name}']
          end
          def #{method_name}=(value)
            @properties[:'#{property_name}']=value
          end
        EVALCODE
      end

    end

    class Type

      attr_accessor :properties
      property_attr_accessor :repository_id, :repositoryId
      property_attr_accessor :id, :id
      property_attr_accessor :local_name, :localName
      property_attr_accessor :local_namespace, :localNamespace
      property_attr_accessor :display_name, :displayName
      property_attr_accessor :base_id, :baseId
      property_attr_accessor :parent_id, :parentId
      property_attr_accessor :creatable, :creatable
      property_attr_accessor :fileable, :fileable
      property_attr_accessor :query_name, :queryName
      property_attr_accessor :queryable, :queryable
      property_attr_accessor :fulltext_indexed, :fulltextIndexed
      property_attr_accessor :included_in_supertype_query, :includedInSupertypeQuery
      property_attr_accessor :controllable_policy, :controllablePolicy
      property_attr_accessor :controllable_acl, :controllableACL
      property_attr_accessor :type_mutability, :typeMutability
      property_attr_accessor :versionable, :versionable
      property_attr_accessor :content_stream_allowed, :contentStreamAllowed
      # see PropertyDefinition
      property_attr_accessor :property_definitions, :propertyDefinitions

      def self.create(hash={})
        t = Type.new
        t.merge(hash.select {|k,v| k!=:propertyDefinitions})
        t.property_definitions = []
        hash[:propertyDefinitions].each do |id, property_hash|
          t.property_definitions<< PropertyDefinition.create(property_hash)
        end
        t
      end

      def initialize()
        @children = []
        @properties = {}
        @properties[:creatable]=true
        @properties[:fileable]=true
        @properties[:queryable]=true
        @properties[:controllablePolicy]=true
        @properties[:controllableACL]=true
        @properties[:fulltextIndexed]=true
        @properties[:includedInSupertypeQuery]=true
        @properties[:versionable]=false
        @properties[:propertyDefinitions] = []
      end

      def []=(key,value)
        @properties[key] = value
      end

      def [](key)
        @properties[key]
      end

      def merge(hash)
        hash.each do |key, value|
          set_property(key, value)
        end
      end

      def set_property(key, value)
        if(different_property_name?(key))
          property_name = get_property_for_different_property_name(key)
          @properties[property_name] = value
        else
          @properties[key] = value
        end
      end

      def children()
        @children
      end

      def children=(children)
        @children = children
      end

      def to_hash()
        props = @properties.dup
        props.delete_if { |key,val| val.nil?}
        
        propertyDefinitions = {}
        props[:propertyDefinitions].each do |pd|
          propertyDefinitions[pd.id] = pd.to_hash
        end
        props[:propertyDefinitions] = propertyDefinitions
        
        props
      end

      private
        def different_property_name?(key)
          @@property_map.has_key?(key)
        end

        def get_property_for_different_property_name(key)
          @@property_map[key]
        end

      class PropertyDefinition
        attr_accessor :id
        attr_accessor :name
        attr_accessor :description
        attr_accessor :local_namespace
        attr_accessor :local_name
        attr_accessor :query_name
        attr_accessor :property_type
        attr_accessor :cardinality
        attr_accessor :updatability
        attr_accessor :queryable
        attr_accessor :orderable
        attr_accessor :required
        attr_accessor :inherited
        attr_accessor :default_value
        attr_accessor :open_choice
        attr_accessor :choices

        def self.create(h={})
          p = PropertyDefinition.new()
          p.id=h[:id]
          p.name=h[:name]
          p.description=h[:description]
          p.local_namespace=h[:localNamespace]
          p.local_name=h[:localName]
          p.query_name=h[:queryName]
          p.property_type=h[:propertyType]
          p.cardinality=h[:cardinality]
          p.updatability=h[:updatability]
          p.queryable=h[:queryable]
          p.orderable=h[:orderable]
          p.required=h[:required]
          p.inherited=h[:inherited]
          p.default_value=h[:defaultValue]
          p.open_choice=h[:openChoice]
          p.choices=h[:choices]
          p
        end

        def initialize()
          @property_type=:string
          @cardinality=:single
          @updatability=:readwrite
          @queryable=true
          @orderable=true
          @required=false
          @inherited=false
        end

        def to_hash()
          h = {}
          h[:id]=id
          h[:name]=name
          h[:description]=description
          h[:localNamespace]=local_namespace
          h[:localName]=local_name
          h[:queryName]=query_name
          h[:propertyType]=property_type
          h[:cardinality]=cardinality
          h[:updatability]=updatability
          h[:queryable]=queryable
          h[:orderable]=orderable
          h[:required]=required
          h[:inherited]=inherited
          h[:defaultValue]=default_value
          h[:openChoice]=open_choice
          h[:choices]=choices

          h.select { |k, v| !v.nil? }
        end

      end
    end
  end
end