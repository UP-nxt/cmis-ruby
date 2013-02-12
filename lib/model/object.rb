require_relative 'services'

class Object
    def self.create(raw)
        base_type_id = raw['cmis:baseTypeId']
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

    attr_reader :repository_id
    attr_reader :object_id
    attr_reader :base_type_id
    attr_reader :object_type_id
    attr_reader :secondary_object_type_ids
    attr_reader :name
    attr_reader :description
    attr_reader :created_by
    attr_reader :creation_date
    attr_reader :last_modified_by
    attr_reader :last_modification_date
    attr_reader :change_token

    attr_reader :properties

    def repository

    end

    def object_type

    end

    def delete
        Services.object.delete_object(repository_id, object_id, true)
    end

    def allowable_actions

    end

    def relationships(direction)

    end

    def policies

    end
end