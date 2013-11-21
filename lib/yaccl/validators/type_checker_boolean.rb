module YACCL
  module Validator
    class TypeCheckerBoolean < Checker
      @@type_boolean_properties = ['creatable', 'fileable', 'queryable', 'controllablePolicy', 'controllableACL', 'fulltextIndexed', 'includedInSupertypeQuery', 'versionable']
      @@property_definitions_boolean_properties = ['queryable', 'orderable', 'required', 'inherited']

      def valid?(req, opt)
        return true if !(req[:cmisaction]=='createType' || req[:cmisaction]=='updateType')
        
        type = MultiJson.load(req[:type])

        check_booleans(type)
      end

      def fix(req, opt)
        type = MultiJson.load(req[:type])

        if(!check_booleans(type))
          # fix booleans for first level in type
          @@type_boolean_properties.each do |key|
            value = get_property_value_and_warn(key, type[key])
            type[key] = value
          end

          # fix booleans for propertyDefinitions in type
          type['propertyDefinitions'].each do |id, pd|
            @@property_definitions_boolean_properties.each do |key|
              value = get_property_value_and_warn(key, pd[key])
              pd[key] = value
            end
          end
        end

        req[:type] = MultiJson.dump(type)

        [req, opt]
      end

      private
        def check_booleans(type)
          type_valid = @@type_boolean_properties.inject(true) { |result, value| result && is_boolean?(value) }
          
          property_definitions_valid = true
          type['propertyDefinitions'].each do |id, property|
            property_definitions_valid = false if !@@property_definitions_boolean_properties.inject(true) { |result, value| result && is_boolean?(value) }
          end

          type_valid && property_definitions_valid
        end

        def is_boolean?(val)
          return false if !(val.is_a?(TrueClass) || val.is_a?(FalseClass)) 
          true
        end

        def represents_boolean?(value)
          value=='false' || value=='true' || value==:true || value==:false
        end

        def get_represented_boolean(value)
          if value=='false' || value==:false
            return false
          elsif value=='true' || value==:true
            return true
          end
        end

        def get_property_value_and_warn(key, value)
          if(!is_boolean?(value))
            if(represents_boolean?(value))
              old_value_class = value.class
              value = get_represented_boolean(value)
              warn("Changed property for \"#{key}\" from \"#{old_value_class}(#{value})\" to \"#{value.class}(#{value})\"")
            else
              raise "\"#{key}\" must be boolean. Request: #{req.to_json}"
            end
          end
          value
        end

    end
  end
end