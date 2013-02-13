require_relative 'folder'
require_relative 'document'
require_relative 'relationship'
require_relative 'policy'
require_relative 'item'

module Model
  class ObjectFactory
    def self.create(raw)
      properties = raw[:properties]
      base_type_id = properties[:'cmis:baseTypeId'][:value]
      if 'cmis:folder'.eql?(base_type_id)
        Folder.create(raw)
      elsif 'cmis:document'.eql?(base_type_id)
        Document.create(raw)
      elsif 'cmis:relationship'.eql?(base_type_id)
        Relationship.create(raw)
      elsif 'cmis:policy'.eql?(base_type_id)
        Policy.create(raw)
      elsif 'cmis:item'.eql?(base_type_id)
        Item.create(raw)
      else
        raise "unexpected baseTypeId - #{base_type_id}"
      end
    end
  end
end