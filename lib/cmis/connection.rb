module CMIS
  class Connection
    def initialize(options)
      options.symbolize_keys!

      service_url = options[:service_url] || ENV['CMIS_BROWSER_URL']
      @service_url = service_url or raise "\
      option `:service_url` or ENV['CMIS_BROWSER_URL'] must be set"

      adapter = (options[:adapter] || :net_http).to_sym

      headers = {
        user_agent: "cmis-ruby/#{VERSION} [#{adapter}]"
      }.merge(options[:headers] || {})
      conn_opts = { headers: headers, ssl: options[:ssl] }.compact

      @http = Faraday.new(conn_opts) do |builder|
        builder.request :multipart
        builder.request :url_encoded

        if username = options[:username] || ENV['CMIS_USER']
          password = options[:password] || ENV['CMIS_PASSWORD']
          builder.basic_auth(username, password)
        end

        builder.adapter adapter
        builder.response :logger if options[:log_requests]
      end

      @url_cache = {}
    end

    def execute!(params = {}, options = {})
      options.symbolize_keys!

      params = massage(params)
      query = options[:query] || {}
      headers = options[:headers]|| {}

      url = url(params.delete(:repositoryId), params[:objectId])

      response = if params[:cmisaction]
        @http.post(url, params, headers)
      else
        @http.get(url, params.merge(query), headers)
      end
      parse!(response)
    end

    private

    def massage(hash) # TODO: Extract functionality
      hash.compact!

      if content_hash = hash[:content]
        hash[:content] = Faraday::UploadIO.new(content_hash[:stream],
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

    def url(repository_id, object_id)
      if repository_id.nil?
        @service_url
      else
        urls = repository_urls(repository_id)
        if object_id
          urls[:root_folder_url]
        else
          urls[:repository_url]
        end
      end
    end

    def repository_urls(repository_id)
      if @url_cache[repository_id].nil?
        repository_infos = JSON.parse(@http.get(@service_url).body)
        unless repository_infos.has_key?(repository_id)
          raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
        end

        repository_info = repository_infos[repository_id]
        @url_cache[repository_id] = { repository_url:  repository_info['repositoryUrl'],
                                      root_folder_url: repository_info['rootFolderUrl'] }
      end
      @url_cache[repository_id]
    end

    def parse!(response)
      if response.headers['Content-Type'] =~ /application\/json/
        result = JSON.parse(response.body)
        if result.is_a?(Hash) && ex = result['exception']
          ruby_exception = "CMIS::Exceptions::#{ex.camelize}".constantize
          raise ruby_exception, result['message']
        end
        result.with_indifferent_access
      else
        response.body
      end
    end
  end
end
