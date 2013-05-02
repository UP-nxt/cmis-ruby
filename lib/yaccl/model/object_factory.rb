module YACCL
  module Model
    class ObjectFactory
      def self.create(repository_id, raw)
        base_type_id = if raw[:properties]
          raw[:properties][:'cmis:baseTypeId'][:value]
        elsif raw[:succinctProperties]
          raw[:succinctProperties][:'cmis:baseTypeId']
        else
          raise "Unexpected raw: #{raw}"
        end
        
        case base_type_id
        when 'cmis:folder' then Folder.new(repository_id, raw)
        when 'cmis:document' then Document.new(repository_id, raw)
        when 'cmis:relationship' then Relationship.new(repository_id, raw)
        when 'cmis:policy' then Policy.new(repository_id, raw)
        when 'cmis:item' then Item.new(repository_id, raw)
        else raise "Unexpected baseTypeId: #{base_type_id}."
        end
      end
    end
  end
end
