module YACCL
  module Model
    class ObjectFactory
      def self.create(repository_id, raw)
        properties = raw[:properties]
        base_type_id = properties[:'cmis:baseTypeId'][:value]
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
