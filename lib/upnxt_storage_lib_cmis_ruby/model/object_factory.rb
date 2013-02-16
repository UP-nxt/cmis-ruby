module UpnxtStorageLibCmisRuby
  module Model
    class ObjectFactory
      def self.create(repository_id, raw)
        properties = raw[:properties]
        base_type_id = properties[:'cmis:baseTypeId'][:value]
        if 'cmis:folder' == (base_type_id)
          Folder.new(repository_id, raw)
        elsif 'cmis:document' == (base_type_id)
          Document.new(repository_id, raw)
        elsif 'cmis:relationship' == (base_type_id)
          Relationship.new(repository_id, raw)
        elsif 'cmis:policy' == (base_type_id)
          Policy.new(repository_id, raw)
        elsif 'cmis:item' == (base_type_id)
          Item.new(repository_id, raw)
        else
          raise "Unexpected baseTypeId: #{base_type_id}"
        end
      end
    end
  end
end
