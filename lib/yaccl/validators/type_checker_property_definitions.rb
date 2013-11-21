module YACCL
  module Validator
    class TypeCheckerPropertyDefinitions < Checker
      
      def valid?(req, opt)
        return true if !(req[:cmisaction]=='updateType')

        type = MultiJson.load(req[:type])
        property_definitions = type['propertyDefinitions']

        !exist_readonly_property_definitions?(property_definitions)
      end

      def fix(req, opt)
        type = MultiJson.load(req[:type])
        property_definitions = type['propertyDefinitions']

        # removing non-writable property definitions
        removed_ids = []
        exist_readonly_property_definitions?(property_definitions) do |id, pd|
          property_definitions.delete(id)
          removed_ids<<id
        end
        req[:type] = MultiJson.dump(type)
        
        warn "Removed property definitions #{removed_ids.join(', ')} because are not updatable or are inherited. New request: #{req.to_json}"

        [req, opt]
      end

      private
        def exist_readonly_property_definitions?(property_definitions)
          property_definitions.select { |id, pd| pd['inherited']==true || !['whencheckedout', 'readwrite'].include?(pd['updatability'].downcase) }.each do |id, pd|
            if(block_given?)
              yield id, pd
            else
              return true
            end
          end
          false
        end

    end
  end
end