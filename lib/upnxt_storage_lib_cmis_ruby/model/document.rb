require_relative 'object'
require_relative 'services'

module Model
  class Document < Object
    def self.create(repository_id, raw)
      Document.new(repository_id, raw)
    end

    def initialize(repository_id, raw = {})
      super(repository_id, raw)
      properties = raw[:properties]
      @is_immutable = get_property_value(properties, :'cmis:isImmutable')
      @is_latest_version = get_property_value(properties, :'cmis:isLatestVersion')
      @is_major_version = get_property_value(properties, :'cmis:isMajorVersion')
      @is_lastest_major_version = get_property_value(properties, :'cmis:isLatestMajorVersion')
      @is_private_working_copy = get_property_value(properties, :'cmis:isPrivateWorkingCopy')
      @version_label = get_property_value(properties, :'cmis:versionLabel')
      @version_series_id = get_property_value(properties, :'cmis:versionSeriesId')
      @version_series_checked_out = get_property_value(properties, :'cmis:isVersionSeriesCheckedOut')
      @version_series_checked_out_by = get_property_value(properties, :'cmis:versionSeriesCheckedOutBy')
      @version_series_checked_out_id = get_property_value(properties, :'cmis:versionSeriesCheckedOutId')
      @checkin_comment = get_property_value(properties, :'cmis:checkinComment')
      @content_stream_length = get_property_value(properties, :'cmis:contentStreamLength')
      @content_stream_mime_type = get_property_value(properties, :'cmis:contentStreamMimeType')
      @content_stream_file_name = get_property_value(properties, :'cmis:contentStreamFileName')
      @content_stream_id = get_property_value(properties, :'cmis:contentStreamId')
    end

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

    def copy_in_folder(folder)
      new_object_id = Services.object.create_document_from_source(repository_id, object_id, nil, folder.object_id, nil, nil, nil, nil)
      repository.object(new_object_id)
    end

    def content
      Services.object.get_content_stream(repository_id, object_id, nil, nil, nil)
    end

    def set_content(stream, mime_type, filename)
      content = {stream: stream, mime_type: mime_type, filename: filename}
      Services.object.set_content_stream(repository_id, object_id, nil, nil, content)
    end

    def set_local_content(stream, mime_type, filename)
      @local_content = {stream: stream, mime_type: mime_type, filename: filename}
    end

    def local_content
      @local_content
    end
  end
end