require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'
require 'date'
require 'typhoeus'
require 'net/http/post/multipart'
require 'multi_json'

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
      options.stringify_keys!
      query = options['query'] || {}
      headers = @headers.merge(options['headers'] || {})

      url = get_url(params.delete(:repositoryId), params[:objectId])

      params = transform_hash(params)

      if params.has_key?(:cmisaction)
        method = params.has_key?(:content) ? 'multipart_post' : 'post'
        body = params
      else
        method = 'get'
        body = nil
        query.merge!(params)
      end

      response = perform_request(method: method, url: url,
                                 query: query, body: body, headers: headers)

      result = response.body

      content_type = if response.respond_to?(:content_type)
        response.content_type
      else
        response.headers['Content-Type']
      end

      result = MultiJson.load(result) if content_type =~ /application\/json/
      result = result.with_indifferent_access if result.is_a? Hash

      check_for_exception!(response.code.to_i, result)

      result
    end

    private

    def check_for_exception!(code, result)
      unless (200...300).include?(code)
        if result.is_a?(Hash) && result['exception']
          exception_class = "CMIS::Exceptions::#{result['exception'].camelize}"
          raise exception_class.constantize, "#{result['message']}"
        end
      end
    end

    def get_url(repository_id, cmis_object_id)
      if repository_id.nil?
        @service_url
      else
        urls = repository_urls(repository_id)
        if cmis_object_id
          urls[:root_folder_url]
        else
          urls[:repository_url]
        end
      end
    end

    def repository_urls(repository_id)
      if @url_cache[repository_id].nil?
        repository_infos = MultiJson.load(perform_request(url: @service_url).body , symbolize_keys: false)
        raise "No repository found with ID #{repository_id}." unless repository_infos.has_key?(repository_id)
        repository_info = repository_infos[repository_id]
        @url_cache[repository_id] = { repository_url:  repository_info['repositoryUrl'],
                                      root_folder_url: repository_info['rootFolderUrl'] }
      end
      @url_cache[repository_id]
    end

    def transform_hash(hash)
      hash.reject! { |_, v| v.nil? }

      if hash.has_key?(:content)
        content = hash.delete(:content)
        hash[:content] = UploadIO.new(content[:stream],
                                      content[:mime_type],
                                      content[:filename])
      end # Move to multipart_post?

      if hash.has_key?(:properties)
        props = hash.delete(:properties)
        if props.is_a?(Hash)
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
      end
      hash
    end

    def perform_request(options)
      if options[:method] == 'multipart_post'
        multipart_post(options)
      else
        typhoeus_request(options)
      end
    end

    def typhoeus_request(options)
      options[:params] = options.delete(:query)
      options[:followlocation] = true
      options[:userpwd] = "#{@username}:#{@password}" if @username
      Typhoeus::Request.new(options.delete(:url), options).run
    end

    def multipart_post(options)
      url = URI.parse(options[:url])
      req = Net::HTTP::Post::Multipart.new(url.path, options[:body])
      options[:headers].each { |key, value| req[key] = value }
      req.basic_auth @username, @password if @username
      opts = url.scheme == 'https' ? { use_ssl: true , verify_mode: OpenSSL::SSL::VERIFY_NONE } : {}
      Net::HTTP.start(url.host, url.port, opts) { |http| http.request(req) }
    end
  end
end
