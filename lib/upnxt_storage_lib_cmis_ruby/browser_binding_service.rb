require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  class BrowserBindingService
    def initialize(service_url)
      @service_url = service_url
    end

    def perform_request(path, params={})
      url = @service_url + path
      if params.has_key?(:cmisaction)
        if params.has_key?(:content)
          Basement.multipart_post(url, params)
        else
          Basement.post(url, body: params)
        end
      else
        Basement.get(url, query: params)
      end
    end

    class Basement
      include HTTParty

      HASH_TRANSFORMER = Proc.new do |hash|
        if hash.has_key?(:properties)
          props = hash.delete(:properties)
          if props.is_a?(Hash)
            props.each_with_index do |(id, value), index|
              hash.merge!("propertyId[#{index}]"    => id,
                          "propertyValue[#{index}]" => value)
            end
          end
        end
        hash
      end

      QUERY_STRING_NORMALIZER = Proc.new do |hash|
        adjusted_hash = HASH_TRANSFORMER.call(hash)
        HTTParty::HashConversions.to_params(adjusted_hash)
      end

      RESULT_PARSER = Proc.new do |body|
        begin
          MultiJson.load(body, symbolize_keys: true)
        rescue Exception
          body
        end
      end

      # For GET and POST, rely on HttParty
      query_string_normalizer QUERY_STRING_NORMALIZER
      parser RESULT_PARSER

      # For Multipart POST, transform and parse result ourselves
      def self.multipart_post(url, options)
        url = URI.parse(url)
        req = Net::HTTP::Post::Multipart.new(url.path, HASH_TRANSFORMER.call(options))
        res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
        RESULT_PARSER.call(res.body)
      end
    end
  end
end
