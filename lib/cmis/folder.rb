module CMIS
  class Folder < Object

    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:parentId cmis:path
                          cmis:allowedChildObjectTypeIds )
    end

    def parent
      repository.object(parent_id) if parent_id
    end

    def allowed_child_object_types
      return nil unless allowed_child_object_type_ids
      allowed_child_object_type_ids.map { |type_id| repository.type(type_id) }
    end

    def children(options = {})
      Children.new(self, options)
    end

    def create(object)
      case object
      when Relationship
        raise "'cmis:relationship' is not fileable. Use Repository#create_relationship"

      when Document
        return object.create_in_folder(self)

      when Folder
        o = connection.execute!({ cmisaction: 'createFolder',
                                  repositoryId: repository.id,
                                  properties: object.properties,
                                  objectId: cmis_object_id })

      when Policy
        o = connection.execute!({ cmisaction: 'createPolicy',
                                  repositoryId: repository.id,
                                  properties: object.properties,
                                  objectId: cmis_object_id })
      when Item
        o = connection.execute!({ cmisaction: 'createItem',
                                  repositoryId: repository.id,
                                  properties: object.properties,
                                  objectId: cmis_object_id })

      else
        raise "Unexpected base_type_id: #{object.base_type_id}"
      end

      ObjectFactory.create(o, repository)
    end

    def delete_tree
      connection.execute!({ cmisaction: 'deleteTree',
                            repositoryId: repository.id,
                            objectId: cmis_object_id })
    end

    def add(object)
      connection.execute!({ cmisaction: 'addObjectToFolder',
                            repositoryId: repository.id,
                            objectId: object.cmis_object_id,
                            folderId: cmis_object_id })
    end

    def remove(object)
      connection.execute!({ cmisaction: 'removeObjectFromFolder',
                            repositoryId: repository.id,
                            objectId: object.cmis_object_id,
                            folderId: cmis_object_id })
    end

  end
end
