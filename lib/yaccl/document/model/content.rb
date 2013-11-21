module YACCL
  module Model
    class Content
      def self.create(raw = {})
        c = Content.new
        c.stream = raw[:stream]
        c.mime_type = raw[:mime_type]
        c.filename = raw[:filename]
        c
      end

      attr_accessor :stream
      attr_accessor :mime_type
      attr_accessor :filename
    end
  end
end