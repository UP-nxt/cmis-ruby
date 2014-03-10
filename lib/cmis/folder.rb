module CMIS
  class Folder < Object
    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:parentId cmis:path
                          cmis:allowedChildObjectTypeIds )
    end

    def parent(opts = {})
      repository.object(parent_id, opts) if parent_id
    end

    def allowed_child_object_types
      return nil unless allowed_child_object_type_ids
      allowed_child_object_type_ids.map { |type_id| repository.type(type_id) }
    end

    def children(opts = {})
      Children.new(self, opts)
    end

    def create(object, opts = {})
      case object
      when Relationship
        raise "'cmis:relationship' is not fileable. Use Repository#create_relationship"

      when Document
        return object.create_in_folder(self, opts)

      when Folder
        o = server.execute!({ cmisaction: 'createFolder',
                              repositoryId: repository.id,
                              properties: object.properties,
                              objectId: cmis_object_id }, opts)

      when Policy
        o = server.execute!({ cmisaction: 'createPolicy',
                              repositoryId: repository.id,
                              properties: object.properties,
                              objectId: cmis_object_id }, opts)
      when Item
        o = server.execute!({ cmisaction: 'createItem',
                              repositoryId: repository.id,
                              properties: object.properties,
                              objectId: cmis_object_id }, opts)

      else
        raise "Unexpected base_type_id: #{object.base_type_id}"
      end

      ObjectFactory.create(o, repository)
    end

    def delete_tree(opts = {})
      server.execute!({ cmisaction: 'deleteTree',
                        repositoryId: repository.id,
                        objectId: cmis_object_id }, opts)
    end

    def add(object, opts = {})
      server.execute!({ cmisaction: 'addObjectToFolder',
                        repositoryId: repository.id,
                        objectId: object.cmis_object_id,
                        folderId: cmis_object_id }, opts)
    end

    def remove(object, opts = {})
      server.execute!({ cmisaction: 'removeObjectFromFolder',
                        repositoryId: repository.id,
                        objectId: object.cmis_object_id,
                        folderId: cmis_object_id }, opts)
    end
  end
end
