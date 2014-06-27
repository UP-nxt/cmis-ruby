require 'cmis/relationships'

module CMIS
  class Object
    include Helpers

    attr_reader :repository
    attr_reader :properties

    def initialize(raw, repository)
      initialize_properties(raw)
      cmis_properties %w( cmis:objectId cmis:baseTypeId cmis:objectTypeId
                          cmis:secondaryObjectTypeIds cmis:name cmis:description
                          cmis:createdBy cmis:creationDate cmis:lastModifiedBy
                          cmis:lastModificationDate cmis:changeToken )

      @repository = repository
    end

    def object_type(opts = {})
      repository.type(object_type_id, opts)
    end

    def delete(opts = {})
      server.execute!({ cmisaction: 'delete',
                        repositoryId: repository.id,
                        objectId: cmis_object_id,
                        allVersions: true }, opts)
    end

    def delete_with_relationships(opts = {})
      relationships.each_relationship(limit: :all) do |rel|
        rel.delete(opts)
      end
      delete(opts)
    end

    def update_properties(properties, opts = {})
      with_change_token do
        server.execute!({ cmisaction: 'update',
                          repositoryId: repository.id,
                          objectId: cmis_object_id,
                          properties: properties,
                          changeToken: change_token }, opts)
      end
    end

    def parents(opts = {})
      result = server.execute!({ cmisselector: 'parents',
                                 repositoryId: repository.id,
                                 objectId: cmis_object_id }, opts)

      result.map { |o| ObjectFactory.create(o['object'], repository) }
    end

    def allowable_actions(opts = {})
      server.execute!({ cmisselector: 'allowableActions',
                        repositoryId: repository.id,
                        objectId: cmis_object_id }, opts)
    end

    def relationships(opts = {})
      Relationships.new(self, opts)
    end

    def policies(opts = {})
      result = server.execute!({ cmisselector: 'policies',
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

      server.execute!(params, opts)
    end

    def move(target_folder, opts = {})
      object_parents = parents

      unless object_parents.size == 1
        raise 'Cannot move object because it is not in exactly one folder'
      end

      server.execute!({ cmisaction: 'move',
                        repositoryId: repository.id,
                        objectId: cmis_object_id,
                        targetFolderId: target_folder.cmis_object_id,
                        sourceFolderId: object_parents.first.cmis_object_id }, opts)
    end

    def acls(opts = {})
      server.execute!({ cmisselector: 'acl',
                        repositoryId: repository.id,
                        objectId: cmis_object_id }, opts)
    end

    def add_aces(aces, opts = {})
      server.execute!({ cmisaction: 'applyACL',
                        repositoryId: repository.id,
                        objectId: cmis_object_id,
                        addACEs: aces }, opts)
    end

    def remove_aces(aces, opts = {})
      server.execute!({ cmisaction: 'applyACL',
                        repositoryId: repository.id,
                        objectId: cmis_object_id,
                        removeACEs: aces }, opts)
    end

    def detached?
      cmis_object_id.nil?
    end

    def refresh(opts = {})
      detached? ? self : repository.object(cmis_object_id, opts)
    end

    def inspect
      "#{self.class}[#{cmis_object_id}] @ #{repository.inspect}"
    end

    private

    def server
      repository.server if repository
    end
  end
end
