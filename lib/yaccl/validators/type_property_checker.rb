module YACCL
  module Validator
    class TypePropertyChecker < Checker
      def valid?(req, opt)
        return true if !req[:properties] || (req[:properties] && !['cmis:folder', 'cmis:document', 'cmis:relationship', 'cmis:policy', 'cmis:item'].include?(req[:properties][:'cmis:baseTypeId']))

        @action = req[:cmisaction]
        type_service = client.type_service()

        repo_id = req[:repositoryId]
        type_id = req[:properties][:'cmis:objectTypeId']

        @type = type_service.get_type_definition(repo_id, type_id)

        req_properties = req[:properties]
        type_properties = @type[:propertyDefinitions]

        if !all_properties_exist?(req_properties, type_properties) || 
          strange_properties?(req_properties, type_properties) || 
          readonly_cmis_properties?(req_properties, type_properties)
          false
        else
          true
        end
      end

      def fix(req, opt)
        # remove strange properties
        req_properties = req[:properties]
        type_properties = @type[:propertyDefinitions]

        # raise exception
        missing_properties = []
        all_properties_exist?(req_properties, type_properties) do |key|
          current_key = key.to_s
          missing_properties << @type[:propertyDefinitions].select { |pd| pd.id==current_key }.first
        end
        raise 'Missing properties: '+missing_properties.map { |prop| prop.id }.join(', ')+".\nProperty details: "+missing_properties.map {|prop| prop.to_hash}.join("\n") if missing_properties.size>0

        # remove strange properties from required properties
        strange_properties = []
        strange_properties?(req_properties, type_properties) do |key|
          req[:properties].delete(key)
          strange_properties<<key
        end  
        warn "Removing #{strange_properties.join(', ')} properties because are not known properties. New request: #{req.to_json}" if strange_properties.size>0

        # remove readonly cmis properties from required properties
        readonly_properties = []
        readonly_cmis_properties?(req_properties, type_properties) do |key|
          req[:properties].delete(key)
          readonly_properties<<key
        end
        warn "Removing #{readonly_properties.join(', ')} properties because are not writable properties. New request: #{req.to_json}" if readonly_properties.size>0

        [req, opt]
      end

      private
        def all_properties_exist?(req_properties, type_properties)
          # check that all required properties are here   
          type_properties.select{ |pd| pd.required }.each do |pd|
            key = pd.id.to_sym
            if !req_properties.has_key?(key) || (req_properties.has_key?(key) && req_properties[key]==nil)
              if(block_given?)
                yield key
              else
                return false 
              end
            end
          end

          #all exist
          true
        end

        def strange_properties?(req_properties, type_properties)
          type_properties = type_properties.dup
          type_properties_ids = type_properties.map { |pd| pd.id.to_sym }
          # check that in req_properties are not too many parameters otherwise will be remove them in fix method
          req_properties.keys.each do |key|
            if !(type_properties_ids.include?(key))
              if(block_given?)
                yield key
              else
                return true
              end
            end 
          end
          #there is no strange to cmis property
          false
        end

        def readonly_cmis_properties?(req_properties, type_properties)
          type_properties = type_properties.dup
          type_properties_ids = type_properties.map { |pd| pd.id.to_sym }

          # check that in req_properties are not any properties with updatability:readonly
          req_properties.keys.each do |key|
            pd = type_properties.select { |pd| pd.id.to_sym==key }.first
            if (type_properties_ids.include?(key) && !allowed_to_write?(pd.updatability))  
              if(block_given?)
                yield key
              else
                return true
              end
            end
          end

          # there are no readonly properties
          false
        end

        def allowed_to_write?(updatability)
          if (!@action.include?('create') and updatability.include?('create'))
            return false
          elsif updatability=='readonly'
            return false
          end

          true
        end

        def action_includes?(word)
          lambda { |updatability| @action.include?(word) && updatability.include?(word) }
        end

    end
  end
end