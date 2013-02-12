require_relative 'services'

class Document < Object
    def self.create(raw)
        Document.new(raw)
    end

    def initialize(raw)
        super(raw)
        @is_immutable = raw['cmis:isImmutable']
        @is_latest_version = raw['cmis:isLatestVersion']
        @is_major_version = raw['cmis:isMajorVersion']
        @is_lastest_major_version = raw['cmis:isLatestMajorVersion']
        @is_private_working_copy = raw['cmis:isPrivateWorkingCopy']
        @version_label = raw['cmis:versionLabel']
        @version_series_id = raw['cmis:versionSeriesId']
        @version_series_checked_out = raw['cmis:isVersionSeriesCheckedOut']
        @version_series_checked_out_by = raw['cmis:versionSeriesCheckedOutBy']
        @version_series_checked_out_id = raw['cmis:versionSeriesCheckedOutId']
        @checkin_comment = raw['cmis:checkinComment']
        @content_stream_length = raw['cmis:contentStreamLength']
        @content_stream_mime_type = raw['cmis:contentStreamMimeType']
        @content_stream_file_name = raw['cmis:contentStreamFileName']
        @content_stream_id = raw['cmis:contentStreamId']
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
end