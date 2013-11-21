module YACCL
  module Model
    class Document < Object

      attr_accessor :parent_id
      property_attr_accessor :repository_id, :'cmis:repositoryId'
      property_attr_accessor :id, :'cmis:objectId'
      property_attr_accessor :name, :'cmis:name'
      property_attr_accessor :immutable?, :'cmis:isImmutable'
      property_attr_accessor :latest_version?, :'cmis:isLatestVersion'
      property_attr_accessor :major_version?, :'cmis:isMajorVersion'
      property_attr_accessor :latest_major_version?, :'cmis:isLatestMajorVersion'
      property_attr_accessor :private_working_copy?, :'cmis:isPrivateWorkingCopy'
      property_attr_accessor :version_label, :'cmis:versionLabel'
      property_attr_accessor :version_series_id, :'cmis:versionSeriesId'
      property_attr_accessor :version_series_checked_out?, :'cmis:isVersionSeriesCheckedOut'
      property_attr_accessor :version_series_checked_out_by, :'cmis:versionSeriesCheckedOutBy'
      property_attr_accessor :version_series_checked_out_id, :'cmis:versionSeriesCheckedOutId'
      property_attr_accessor :checkin_comment, :'cmis:checkinComment'
      property_attr_accessor :content_stream_length, :'cmis:contentStreamLength'
      property_attr_accessor :content_stream_mime_type, :'cmis:contentStreamMimeType'
      property_attr_accessor :content_stream_file_name, :'cmis:contentStreamFileName'
      property_attr_accessor :content_stream_id, :'cmis:contentStreamId'
      attr_accessor :local_content

      def self.create(raw = {})
        f = Document.new
        f.merge(raw)
        f
      end

      def initialize()
        super
        @properties[:'cmis:baseTypeId']='cmis:document'
        @properties[:'cmis:objectTypeId']='cmis:document'
      end
      
      # save immediately if this object is not detached 
      def set_content(content)
        d = self
        if detached?
          @local_content = content
        else
          d = save_content(content)
        end
        d
      end

      # lazy load
      def content
        if detached?
          @local_content
        else
          retrieve_content()
        end
      end

      private
        def save_content(content)
          ds = @client.document_service()
          new_d = ds.save_content_stream(repository_id, id, content, change_token)
          new_d
        end

        def retrieve_content()
          ds = @client.document_service()
          begin
            ds.get_content_stream(repository_id, id)
          rescue YACCL::CMISRequestError
            nil
          end
        end
    end
  end
end