require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  module Services
    class CMISRequestError < RuntimeError; end

    module Internal
      class BrowserBindingService
        def initialize(service_url)
          @service_url = service_url
        end

        def perform_request(required_params={}, optional_params={})
          url = get_url(required_params.delete(:repositoryId), required_params[:objectId])

          optional_params.reject! { |_, v| v.nil? }
          params = transform_hash(required_params.merge(optional_params))

          response = if params.has_key?(:cmisaction)
            if params.has_key?(:content)
              Basement.multipart_post(url, params)
            else
              Basement.post(url, body: params)
            end
          else
            Basement.get(url, query: params)
          end

          result = response.body
          if response.content_type == 'application/json'
            result = MultiJson.load(result, symbolize_keys: true)
            if result.is_a?(Hash) && result.has_key?(:exception)
              raise CMISRequestError, "#{result[:exception]} -- #{result[:message]}"
            end
          end
          result
        end

        private

        def get_url(repository_id, object_id)
          if repository_id.nil?
            @service_url
          else
            repository_info = Basement.get(@service_url)[repository_id]
            repository_info[object_id.nil? ? 'repositoryUrl' : 'rootFolderUrl']
          end
        end

        def check(hash)
          # maxItems integer
          # skipcount integer
          # filter nil / cs list (array) / *
          # includeRelationships none source target both
          # includePolicyIds boolean
          # renditionFilter TODO
          # includeACL boolean
          # includeAllowableActions boolean
          # orderBy cs list (+ ASC/DESC)
        end

        def transform_hash(hash)
          if hash.has_key?(:content)
            content = hash.delete(:content)
            hash[:content] = UploadIO.new(content[:stream],
                                          content[:mime_type],
                                          content[:filename])
          end
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

        class Basement
          include HTTParty

          def self.multipart_post(url, options)
            url = URI.parse(url)
            Net::HTTP.start(url.host, url.port) do |http|
              http.request(Net::HTTP::Post::Multipart.new(url.path, options))
            end
          end
        end
      end
    end
  end
end
