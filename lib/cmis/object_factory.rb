module CMIS
  class ObjectFactory
    def self.create(raw, repository)
      case base_type_id(raw)
      when 'cmis:object' then Object.new(raw, repository)
      when 'cmis:folder' then Folder.new(raw, repository)
      when 'cmis:document' then Document.new(raw, repository)
      when 'cmis:relationship' then Relationship.new(raw, repository)
      when 'cmis:policy' then Policy.new(raw, repository)
      when 'cmis:item' then Item.new(raw, repository)
      else raise "Unexpected baseTypeId: #{base_type_id(raw)}, response: #{raw}"
      end
    end

    private

    def self.base_type_id(raw)
      if raw['properties'] && raw['properties']['cmis:baseTypeId']
        raw['properties']['cmis:baseTypeId']['value']
      elsif raw['succinctProperties'] && raw['succinctProperties']['cmis:baseTypeId']
        raw['succinctProperties']['cmis:baseTypeId']
      else
        'cmis:object' # no base type id, construct a poco
      end
    end
  end
end
