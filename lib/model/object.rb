require_relative 'server'
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
        Server.repository(repository_id)
    end

    def object_type
        repository.type(object_type_id)
    end

    def delete
        Services.object.delete_object(repository_id, object_id, true)
    end

    def allowable_actions
        Services.object.get_allowable_actions(repository_id, object_id)
    end

    def relationships(direction)
        Services.relationship.get_object_relationships(repository_id, object_id, nil, direction, nil, nil, false, nil, nil).map do |r|
            Relationship.create(r)
        end
    end

    def policies
        Services.policy.get_applied_policies(repository_id, object_id, nil).map do |policy|
            Policy.create(policy)
        end
    end

    # remove from all folders
    def unfile
        Services.multi_filing.remove_object_from_folder(repository_id, object_id, nil)
    end
end