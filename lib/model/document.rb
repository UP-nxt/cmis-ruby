require_relative 'services'

class Document < Object
    def self.create(raw)
    end

    attr_reader :is_immutable
    attr_reader :is_latest_version
    attr_reader :is_major_version
    attr_reader :is_private_working_copy
    attr_reader :version_label
    attr_reader :version_series_id
    attr_reader :version_series_checked_out_by
    attr_reader :version_series_checked_out_id
    attr_reader :checkin_comment
    attr_reader :content_stream_length
    attr_reader :content_stream_mime_type
    attr_reader :content_stream_file_name
    attr_reader :content_stream_id

    def copy

    end
end