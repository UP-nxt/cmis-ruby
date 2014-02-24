module CMIS
  class Object

    include Helpers

    attr_reader :connection
    attr_reader :repository
    attr_accessor :properties

    def initialize(raw, repository)
      initialize_properties(raw)
      cmis_properties %w( cmis:objectId cmis:baseTypeId cmis:objectTypeId
                          cmis:secondaryObjectTypeIds cmis:name cmis:description
                          cmis:createdBy cmis:creationDate cmis:lastModifiedBy
                          cmis:lastModificationDate cmis:changeToken )

      @repository = repository
      @connection = repository.connection
    end

    def object_type
      repository.type(object_type_id)
    end

    def delete
      connection.execute!({ cmisaction: 'delete',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            allVersions: true })
    end

    def update_properties(properties)
      update_change_token connection.execute!({ cmisaction: 'update',
                                                repositoryId: repository.id,
                                                objectId: cmis_object_id,
                                                properties: properties,
                                                changeToken: change_token })
    end

    def parents
      result = connection.execute!({ cmisselector: 'parents',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id })

      result.map { |o| ObjectFactory.create(o['object'], repository) }
    end

    def allowable_actions
      connection.execute!({ cmisselector: 'allowableActions',
                            repositoryId: repository.id,
                            objectId: cmis_object_id })
    end

    def relationships(direction = :either)
      result = connection.execute!({ cmisselector: 'relationships',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id,
                                     relationshipDirection: direction })

      result['objects'].map { |r| Relationship.new(r, repository) }
    end

    def policies
      result = connection.execute!({ cmisselector: 'policies',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id })

      result.map { |r| Policy.new(r, repository) }
    end

    # By default removes from all folders
    def unfile(folder = nil)
      options = { repositoryId: repository.id,
                  cmisaction: 'removeObjectFromFolder',
                  objectId: cmis_object_id }
      options[:folderId] = folder.cmis_object_id if folder

      connection.execute!(options)
    end

    def move(target_folder)
      object_parents = parents

      unless object_parents.size == 1
        raise 'Cannot move object because it is not in exactly one folder'
      end

      connection.execute!({ cmisaction: 'move',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            targetFolderId: target_folder.cmis_object_id,
                            sourceFolderId: object_parents.first.cmis_object_id })
    end

    def acls
      connection.execute!({ cmisselector: 'acl',
                            repositoryId: repository.id,
                            objectId: cmis_object_id })
    end

    def add_aces(aces)
      connection.execute!({ cmisaction: 'applyACL',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            addACEs: aces })
    end

    def remove_aces(aces)
      connection.execute!({ cmisaction: 'applyACL',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            removeACEs: aces })
    end

    def detached?
      cmis_object_id.nil?
    end

  end
end
