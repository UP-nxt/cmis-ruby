require 'core_ext/hash/keys'

module CMIS
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

    def create_in_folder(folder, opts = {})
      r = server.execute!({ cmisaction: 'createDocument',
                            repositoryId: repository.id,
                            properties: properties,
                            objectId: folder.cmis_object_id,
                            folderId: folder.cmis_object_id,
                            content: @local_content }, opts)

      ObjectFactory.create(r, repository)
    end

    def copy_in_folder(folder, opts = {})
      id = server.execute!({ cmisaction: 'createDocument',
                             repositoryId: repository.id,
                             sourceId: cmis_object_id,
                             objectId: folder.cmis_object_id }, opts)

      repository.object(id)
    end

    def content(opts = {})
      server.execute!({ cmisselector: 'content',
                        repositoryId: repository.id,
                        objectId: cmis_object_id }, opts)

    rescue Exceptions::Constraint => e
      if e.message =~ /no content stream/
        nil
      else
        raise e
      end
    end

    def content=(opts = {})
      opts.symbolize_keys!
      content = { stream: opts.delete(:stream),
                  mime_type: opts.delete(:mime_type),
                  filename: opts.delete(:filename) }

      if content[:stream].is_a? String
        content[:stream] = StringIO.new(content[:stream])
      end

      if detached?
        @local_content = content
      else
        with_change_token do
          server.execute!({ cmisaction: 'setContent',
                            repositoryId: repository.id,
                            objectId: cmis_object_id,
                            content: content,
                            changeToken: change_token }, opts)
        end
      end
    end
  end
end
