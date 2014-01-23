require 'date'
require 'typhoeus'
require 'net/http/post/multipart'
require 'multi_json'
require_relative 'simple_cache'

module YACCL
  module Services
    class CMISRequestError < RuntimeError; end

    module Internal
      class BrowserBindingService

        @@url_cache = SimpleCache::MemoryCache.new

        def initialize(service_url, basic_auth_username=nil, basic_auth_password=nil, succinct_properties=true)
          @service_url = service_url
          @basement = Basement.new(basic_auth_username, basic_auth_password)
          @succinct_properties = succinct_properties
        end

        def perform_request(required_params={}, optional_params={})
          headers = required_params[:properties].delete(:headers) if required_params[:properties]
          headers ||= {}
          url = get_url(required_params.delete(:repositoryId), required_params[:objectId])

          required_params[:succinct] ||= @succinct_properties
          optional_params.reject! { |_, v| v.nil? }

          params = transform_hash(required_params.merge(optional_params))

          check(params)

          response = if params.has_key?(:cmisaction)
            if params.has_key?(:content)
              @basement.multipart_post(url, params, headers)
            else
              @basement.post(url: url, body: params, headers: headers)
            end
          else
            @basement.get(url: url, query: params, headers: headers)
          end


          result = response.body

          content_type = if response.respond_to?(:content_type)
            response.content_type
          else
            response.headers['Content-Type']
          end

          result = MultiJson.load(result, symbolize_keys: true) if content_type =~ /application\/json/

          unless (200...300).include?(response.code.to_i)
            if result.is_a?(Hash) && result.has_key?(:exception)
              raise CMISRequestError, "#{response.code} -- #{result[:exception]} -- #{result[:message]}"
            else
              raise CMISRequestError, "#{response.code} -- #{result}"
            end
          end

          result
        end

        private

        def get_url(repository_id, cmis_object_id)
          if repository_id.nil?
            @service_url
          else
            repository_urls(repository_id)[cmis_object_id ? :root_folder_url : :repository_url]
          end
        end

        def repository_urls(repository_id)
          if @@url_cache[repository_id].nil?
            repository_infos = MultiJson.load(@basement.get(url: @service_url).body , symbolize_keys: false)            
            raise "No repository found with ID #{repository_id}." unless repository_infos.has_key?(repository_id)
            repository_info = repository_infos[repository_id]
            @@url_cache[repository_id] = { repository_url: repository_info['repositoryUrl'],
                                           root_folder_url: repository_info['rootFolderUrl'] }
          end
          @@url_cache[repository_id]
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
                value = value.to_time if value.is_a?(Date) or value.is_a?(DateTime)
                value = (value.to_f * 1000).to_i if value.is_a?(Time)
                if value.is_a?(Array)
                  hash.merge!("propertyId[#{index}]" => id)
                  value.each_with_index { |v, idx|
                    hash.merge!("propertyValue[#{index}][#{idx}]" => value[idx])
                  }
                else
                  hash.merge!("propertyId[#{index}]" => id,
                              "propertyValue[#{index}]" => value)
                end
              end
            end
          end
          hash
        end

        class Basement

          def initialize(user, pass)
            @username = user
            @password = pass
          end

          def get(params)
            Typhoeus::Request.new(
              params[:url],
              userpwd: "#{@username}:#{@password}",
              method: :get,
              body: params[:body],
              params: params[:query],
              headers: params[:headers],
              followlocation: true
            ).run
          end

          def post(params)            
            Typhoeus::Request.new(
              params[:url],
              userpwd: "#{@username}:#{@password}",
              method: :post,
              body: params[:body],
              params: params[:query],
              headers: params[:headers]
            ).run
          end

          def multipart_post(url, options, headers)
            url = URI.parse(url)
            req = Net::HTTP::Post::Multipart.new(url.path, options)
            headers.each {|key, value| req[key] = value }
            req.basic_auth @username, @password unless @username.nil?
            opts = url.scheme == 'https' ? { use_ssl: true , verify_mode: OpenSSL::SSL::VERIFY_NONE } : {}
            Net::HTTP.start(url.host, url.port, opts) { |http| http.request(req) }
          end
        end
      end
    end
  end
end
