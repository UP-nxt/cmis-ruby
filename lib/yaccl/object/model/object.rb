module YACCL
  module Model

    class Object
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
        method_name = method_name.to_s
        getter_method_name = method_name
        setter_method_name = if method_name.include?('?')
          method_name.delete('?')
        else
          method_name
        end
        
        class_eval <<-EVALCODE
          def #{getter_method_name}
            @properties[:'#{property_name}']
          end
          def #{setter_method_name}=(value)
            @properties[:'#{property_name}']=value
          end
        EVALCODE
      end

    end
    
    class Object

      attr_accessor :properties
      property_attr_accessor :id, :'cmis:objectId'
      property_attr_accessor :base_type_id, :'cmis:baseTypeId'
      property_attr_accessor :object_type_id, :'cmis:objectTypeId'
      property_attr_accessor :change_token, :'cmis:changeToken'

      attr_accessor :allowable_actions
      attr_accessor :acl
      attr_accessor :exact_acl
      attr_accessor :policy_ids

      def initialize()
        @client=nil
        @properties = {}
      end

      def detached?
        return true if @client.nil?
        false
      end

      def detach()
        @client = nil
      end

      def client=(value)
        @client = value
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
        @properties.delete_if { |key,val| val.nil?}
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