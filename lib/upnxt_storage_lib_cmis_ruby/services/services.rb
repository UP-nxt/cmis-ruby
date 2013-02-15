require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  module Services
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    class BrowserBindingService
      def initialize(service_url)
        @service_url = service_url
      end

      def perform_request(required_params={}, optional_params={})
        url = get_url(required_params.delete(:repositoryId), required_params[:objectId])

        optional_params.reject! { |_, v| v.nil? }
        params = required_params.merge(optional_params)

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

      private

      def get_url(repository_id, object_id)
        if repository_id.nil?
          @service_url
        else
          repository_info = Basement.get(@service_url)[repository_id.to_sym]
          repository_info[object_id.nil? ? :repositoryUrl : :rootFolderUrl]
        end
      end

      class Basement
        include HTTParty

        HASH_TRANSFORMER = Proc.new do |hash|
          if hash.has_key?(:properties)
            props = hash.delete(:properties)
            if props.is_a?(Hash)
              props.each_with_index do |(id, value), index|
                hash.merge!("propertyId[#{index}]" => id,
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
          MultiJson.load(body, symbolize_keys: true)
        end

        # For GET and POST, tell HTTParty to transform params and parse result
        query_string_normalizer QUERY_STRING_NORMALIZER
        parser RESULT_PARSER

        def self.multipart_post(url, options)
          url = URI.parse(url)
          req = Net::HTTP::Post::Multipart.new(url.path, HASH_TRANSFORMER.call(options))
          res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
          RESULT_PARSER.call(res.body)
        end
      end
    end
  end
end
