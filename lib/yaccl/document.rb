module YACCL
  class Document < Object

    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:isImmutable cmis:isLatestVersion
                          cmis:isMajorVersion cmis:isLatestMajorVersion
                          cmis:isPrivateWorkingCopy cmis:versionLabel
                          cmis:versionSeriesId cmis:isVersionSeriesCheckedOut
                          cmis:versionSeriesCheckedOutBy
                          cmis:versionSeriesCheckedOutId cmis:checkinComment
                          cmis:contentStreamLength cmis:contentStreamMimeType
                          cmis:contentStreamFileName cmis:contentStreamId )
    end

    def create_in_folder(folder)
      r = connection.execute!({ cmisaction: 'createDocument',
                                repositoryId: repository.id,
                                properties: properties,
                                objectId: folder.cmis_object_id,
                                folderId: folder.cmis_object_id,
                                content: @local_content })

      ObjectFactory.create(r, repository)
    end

    def copy_in_folder(folder)
      id = connection.execute!({ cmisaction: 'createDocument',
                                 repositoryId: repository.id,
                                 sourceId: cmis_object_id,
                                 objectId: folder.cmis_object_id })

      repository.object(id)
    end

    def content
      connection.execute!({ cmisselector: 'content',
                            repositoryId: repository.id,
                            objectId: cmis_object_id })

    rescue YACCL::CMISRequestError
      nil
    end

    def set_content(stream, mime_type, filename)
      content = { stream: stream,
                  mime_type: mime_type,
                  filename: filename }

      if detached?
        @local_content = content
      else
        update_change_token connection.execute!({ cmisaction: 'setContent',
                                                  repositoryId: repository.id,
                                                  objectId: cmis_object_id,
                                                  content: content,
                                                  changeToken: change_token })
      end
    end

  end
end
