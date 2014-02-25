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

    def object_type(opts = {})
      repository.type(object_type_id, opts)
    end

    def delete(opts = {})
      connection.execute!({ cmisaction: 'delete',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            allVersions: true }, opts)
    end

    def update_properties(properties, opts = {})
      update_change_token connection.execute!({ cmisaction: 'update',
                                                repositoryId: repository.id,
                                                objectId: cmis_object_id,
                                                properties: properties,
                                                changeToken: change_token }, opts)
    end

    def parents(opts = {})
      result = connection.execute!({ cmisselector: 'parents',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id }, opts)

      result.map { |o| ObjectFactory.create(o['object'], repository) }
    end

    def allowable_actions(opts = {})
      connection.execute!({ cmisselector: 'allowableActions',
                            repositoryId: repository.id,
                            objectId: cmis_object_id }, opts)
    end

    def relationships(direction = :either, opts = {})
      result = connection.execute!({ cmisselector: 'relationships',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id,
                                     relationshipDirection: direction }, opts)

      result['objects'].map { |r| Relationship.new(r, repository) }
    end

    def policies(opts = {})
      result = connection.execute!({ cmisselector: 'policies',
                                     repositoryId: repository.id,
                                     objectId: cmis_object_id }, opts)

      result.map { |r| Policy.new(r, repository) }
    end

    # By default removes from all folders
    def unfile(folder = nil, opts = {})
      params = { repositoryId: repository.id,
                 cmisaction: 'removeObjectFromFolder',
                 objectId: cmis_object_id }
      params.update!(folderId: folder.cmis_object_id) if folder

      connection.execute!(params, opts)
    end

    def move(target_folder, opts = {})
      object_parents = parents

      unless object_parents.size == 1
        raise 'Cannot move object because it is not in exactly one folder'
      end

      connection.execute!({ cmisaction: 'move',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            targetFolderId: target_folder.cmis_object_id,
                            sourceFolderId: object_parents.first.cmis_object_id }, opts)
    end

    def acls(opts = {})
      connection.execute!({ cmisselector: 'acl',
                            repositoryId: repository.id,
                            objectId: cmis_object_id }, opts)
    end

    def add_aces(aces, opts = {})
      connection.execute!({ cmisaction: 'applyACL',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            addACEs: aces }, opts)
    end

    def remove_aces(aces, opts = {})
      connection.execute!({ cmisaction: 'applyACL',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            removeACEs: aces }, opts)
    end

    def detached?
      cmis_object_id.nil?
    end
  end
end
