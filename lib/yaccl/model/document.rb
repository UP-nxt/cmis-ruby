module YACCL
  module Model
    class Document < Object
      attr_reader :is_immutable
      attr_reader :is_latest_version
      attr_reader :is_major_version
      attr_reader :is_latest_major_version
      attr_reader :is_private_working_copy
      attr_reader :version_label
      attr_reader :version_series_id
      attr_reader :version_series_checked_out
      attr_reader :version_series_checked_out_by
      attr_reader :version_series_checked_out_id
      attr_reader :checkin_comment
      attr_reader :content_stream_length
      attr_reader :content_stream_mime_type
      attr_reader :content_stream_file_name
      attr_reader :content_stream_id

      def initialize(repository_id, raw={})
        super
        @is_immutable = @properties[:'cmis:isImmutable']
        @is_latest_version = @properties[:'cmis:isLatestVersion']
        @is_major_version = @properties[:'cmis:isMajorVersion']
        @is_lastest_major_version = @properties[:'cmis:isLatestMajorVersion']
        @is_private_working_copy = @properties[:'cmis:isPrivateWorkingCopy']
        @version_label = @properties[:'cmis:versionLabel']
        @version_series_id = @properties[:'cmis:versionSeriesId']
        @version_series_checked_out = @properties[:'cmis:isVersionSeriesCheckedOut']
        @version_series_checked_out_by = @properties[:'cmis:versionSeriesCheckedOutBy']
        @version_series_checked_out_id = @properties[:'cmis:versionSeriesCheckedOutId']
        @checkin_comment = @properties[:'cmis:checkinComment']
        @content_stream_length = @properties[:'cmis:contentStreamLength']
        @content_stream_mime_type = @properties[:'cmis:contentStreamMimeType']
        @content_stream_file_name = @properties[:'cmis:contentStreamFileName']
        @content_stream_id = @properties[:'cmis:contentStreamId']
      end

      def copy_in_folder(folder)
        new_object_id = Services.create_document_from_source(repository_id, object_id, nil, folder.object_id, nil, nil, nil, nil)
        repository.object(new_object_id)
      end

      def content
        begin
          Services.get_content_stream(repository_id, object_id, nil, nil, nil)
        rescue Services::CMISRequestError
          nil
        end
      end

      def set_content(stream, mime_type, filename)
        content = {stream: stream, mime_type: mime_type, filename: filename}
        if detached?
          @local_content = content
        else
          r = Services.set_content_stream(repository_id, object_id, nil, change_token, content)
          change_token = r[:properties][:'cmis:changeToken'][:value]
        end
      end

      def create_in_folder(folder_id)
        hash = Services.create_document(repository_id, create_properties, folder_id, @local_content, nil, nil, nil, nil)
        ObjectFactory.create(repository_id, hash)
      end
    end
  end
end
