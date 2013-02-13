require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  module BrowserBindingService
    include HTTParty

    base_uri 'http://localhost:8080/upncmis/browser'

    QUERY_HASH_TRANSFORMER = Proc.new do |hash|
      HashConversions.transform(hash)
    end

    QUERY_STRING_NORMALIZER = Proc.new do |hash|
      adjusted_hash = QUERY_HASH_TRANSFORMER.call(hash)
      HTTParty::HashConversions.to_params(adjusted_hash)
    end

    JSON_RESULT_PARSER = Proc.new do |body|
      MultiJson.load(body, symbolize_keys: true)
    end

    # For GET and POST, rely on HttParty
    query_string_normalizer QUERY_STRING_NORMALIZER
    parser JSON_RESULT_PARSER

    # For Multipart POST, normalize params and parse result
    def self.multipart_post(path, options={})
      url = URI.parse("#{base_uri}#{path}")
      body = QUERY_HASH_TRANSFORMER.call(options[:body])
      req = Net::HTTP::Post::Multipart.new(url.path, body)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      JSON_RESULT_PARSER.call(res.body)
    end

    module HashConversions
      def self.transform(hash)
        if hash.has_key?(:properties)
          props = hash.delete(:properties)
          if props.is_a?(Hash)
            props.each_with_index do |(k, v), i|
              hash.merge!("propertyId[#{i}]" => k, "propertyValue[#{i}]" => v)
            end
          end
        end
        hash
      end
    end
  end
end
