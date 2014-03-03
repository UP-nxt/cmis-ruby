require 'active_support'
require 'json'
require 'typhoeus'
require 'net/http/post/multipart'

module CMIS
  class Connection
    def initialize(service_url, username, password, headers)
      @service_url = service_url
      @username = username
      @password = password
      @headers = headers

      @url_cache = {}
    end

    def execute!(params = {}, options = {})
      query, headers = parse_options(options)

      Request.new(service_url: @service_url,
                  url_cache: @url_cache,
                  params: params,
                  query: query,
                  headers: headers,
                  username: @username,
                  password: @password).run
    end

    private

    def parse_options(options)
      options.symbolize_keys!
      query = options[:query] || {}
      headers = @headers
      headers.merge!(options[:headers]) if options[:headers]
      [ query, headers ]
    end

    class Request
      def initialize(options)
        @service_url = options[:service_url]
        @url_cache = options[:url_cache]
        @params = massage(options[:params])
        @repository_id = @params.delete(:repositoryId)
        @query = options[:query]
        @headers = options[:headers]
        @username = options[:username]
        @password = options[:password]
      end

      def run
        case method
        when 'get'
          typhoeus_request
        when 'post'
          typhoeus_request
        when 'multipart_post'
          multipart_post
        end
      end

      private

      def typhoeus_request
        options = {
          method: method,
          body: body,
          params: query,
          headers: @headers,
          followlocation: true
        }
        options[:userpwd] = "#{@username}:#{@password}" if @username
        response = Typhoeus::Request.new(url, options).run
        Response.new(response.headers['Content-Type'], response.body).parse!
      end

      def multipart_post
        uri = URI.parse(url)
        req = Net::HTTP::Post::Multipart.new(uri.path, body)
        @headers.each { |key, value| req[key] = value }
        req.basic_auth @username, @password if @username
        opts = if uri.scheme == 'https'
          { use_ssl: true , verify_mode: OpenSSL::SSL::VERIFY_NONE }
        else
          {}
        end
        Net::HTTP.start(uri.host, uri.port, opts) do |http|
          response = http.request(req)
          Response.new(response['Content-Type'], response.body).parse!
        end
      end

      def url
        if @repository_id.nil?
          @service_url
        else
          urls = repository_urls(@repository_id)
          if @params[:objectId]
            urls[:root_folder_url]
          else
            urls[:repository_url]
          end
        end
      end

      def method
        if @params[:cmisaction]
          if @params[:content]
            'multipart_post'
          else
            'post'
          end
        else
          'get'
        end
      end

      def body
        @params if @params[:cmisaction]
      end

      def query
        if @params[:cmisaction]
          @query
        else
          @params.merge(@query)
        end
      end

      # TODO: Extract functionality
      def massage(hash)
        hash.compact

        if content_hash = hash[:content]
          hash[:content] = UploadIO.new(content_hash[:stream],
                                        content_hash[:mime_type],
                                        content_hash[:filename])
        end

        if props = hash.delete(:properties)
          props.each_with_index do |(id, value), index|
            value = value.to_time if value.is_a?(Date) or value.is_a?(DateTime)
            value = (value.to_f * 1000).to_i if value.is_a?(Time)
            if value.is_a?(Array)
              hash.merge!("propertyId[#{index}]" => id)
              value.each_with_index do |v, idx|
                hash.merge!("propertyValue[#{index}][#{idx}]" => value[idx])
              end
            else
              hash.merge!("propertyId[#{index}]" => id,
                          "propertyValue[#{index}]" => value)
            end
          end
        end
        hash
      end

      def repository_urls(repository_id)
        if @url_cache[repository_id].nil?

          options = { method: 'get' }
          options[:userpwd] = "#{@username}:#{@password}" if @username
          response = Typhoeus::Request.new(@service_url, options).run
          repository_infos = JSON.parse(response.body)

          unless repository_infos.has_key?(repository_id)
            raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
          end

          repository_info = repository_infos[repository_id]
          @url_cache[repository_id] = { repository_url:  repository_info['repositoryUrl'],
                                        root_folder_url: repository_info['rootFolderUrl'] }
        end
        @url_cache[repository_id]
      end
    end

    class Response
      def initialize(content_type, body)
        @content_type = content_type
        @body = body
      end

      def parse!
        return @body unless @content_type =~ /application\/json/

        result = JSON.parse(@body)
        if result.is_a?(Hash) && ex = result['exception']
          raise "CMIS::Exceptions::#{ex.camelize}".constantize, result['message']
        end
        result.with_indifferent_access
      end
    end
  end
end
