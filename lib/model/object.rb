class Object
    def self.create(raw_object)

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