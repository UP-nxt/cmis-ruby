require_relative 'folder'
require_relative 'document'
require_relative 'relationship'
require_relative 'policy'
require_relative 'item'

module Model
  class ObjectFactory
    def self.create(repository_id, raw)
      properties = raw[:properties]
      base_type_id = properties[:'cmis:baseTypeId'][:value]
      if 'cmis:folder'.eql?(base_type_id)
        Folder.new(repository_id, raw)
      elsif 'cmis:document'.eql?(base_type_id)
        Document.new(repository_id, raw)
      elsif 'cmis:relationship'.eql?(base_type_id)
        Relationship.new(repository_id, raw)
      elsif 'cmis:policy'.eql?(base_type_id)
        Policy.new(repository_id, raw)
      elsif 'cmis:item'.eql?(base_type_id)
        Item.new(repository_id, raw)
      else
        raise "unexpected baseTypeId - #{base_type_id}"
      end
    end
  end
end