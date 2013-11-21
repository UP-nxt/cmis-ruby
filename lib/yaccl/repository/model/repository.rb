module YACCL
  module Model

    class Repository
      META_REPOSITORY_ID = 'meta'
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

    class Repository

      property_map input: :repositoryId, property: :id

      attr_accessor :properties
      property_attr_accessor :id
      property_attr_accessor :base_type_id, :'cmis:baseTypeId'
      property_attr_accessor :object_type_id, :'cmis:objectTypeId'
      property_attr_accessor :name, :'cmis:name'

      def self.create(raw)
        r = Repository.new()
        r.merge(raw)
        r
      end

      def initialize()
        @properties = {}
        @properties[:'cmis:objectTypeId'] = 'repository'
      end

      def root_folder_id
        @properties[:rootFolderId]
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

      def to_hash()
        @properties
      end

      private
        def different_property_name?(key)
          @@property_map.has_key?(key)
        end

        def get_property_for_different_property_name(key)
          @@property_map[key]
        end

    end
  end
end