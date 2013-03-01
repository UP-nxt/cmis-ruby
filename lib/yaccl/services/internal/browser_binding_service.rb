require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'
require 'lrucache'

module YACCL
  module Services
    class CMISRequestError < RuntimeError; end

    module Internal
      class BrowserBindingService
        def initialize(service_url)
          @service_url = service_url
          @repository_urls = LRUCache.new(ttl: 1.hour)
          @root_folder_urls = LRUCache.new(ttl: 1.hour)
        end

        def perform_request(required_params={}, optional_params={})
          url = get_url(required_params.delete(:repositoryId), required_params[:objectId])

          optional_params.reject! { |_, v| v.nil? }
          params = transform_hash(required_params.merge(optional_params))

          check(params)

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
            if object_id.nil?
              if @repository_urls.fetch(repository_id).nil?
                repository_url = Basement.get(@service_url)[repository_id]['repositoryUrl']
                @repository_urls.store(repository_id, repository_url)
              end
              return @repository_urls.fetch(repository_id)
            else
              if @root_folder_urls.fetch(repository_id).nil?
                root_folder_url = Basement.get(@service_url)[repository_id]['rootFolderUrl']
                @root_folder_urls.store(repository_id, root_folder_url)
              end
              return @root_folder_urls.fetch(repository_id)
            end
          end
        end

        def check(hash)
          check_in(hash, :includeRelationships, [:none, :source, :target, :both])
        end

        def check_in(hash, key, arr)
          value = hash[key]
          unless value.nil?
            unless arr.include?(value)
              raise ArgumentError, "#{key} must be one of #{arr}."
            end
          end
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
