module CMIS
  class Connection
    def initialize(options)
      options.symbolize_keys!

      @service_url = options[:service_url] || ENV['CMIS_BROWSER_URL'] or \
        raise "option `:service_url` or ENV['CMIS_BROWSER_URL'] must be set"

      adapter = (options[:adapter] || :net_http).to_sym

      headers = {
        user_agent: "cmis-ruby/#{VERSION} [#{adapter}]"
      }.merge(options[:headers] || {})
      conn_opts = { headers: headers, ssl: options[:ssl] }.compact

      @http = Faraday.new(conn_opts) do |builder|
        builder.use RequestModifier
        builder.request :multipart
        builder.request :url_encoded

        if username = options[:username] || ENV['CMIS_USER']
          password = options[:password] || ENV['CMIS_PASSWORD']
          builder.basic_auth(username, password)
        end

        builder.adapter adapter
        builder.response :logger if options[:log_requests]
        builder.use ResponseParser
      end

      @url_cache = {}
    end

    def execute!(params = {}, options = {})
      options.symbolize_keys!

      query = options[:query] || {}
      headers = options[:headers]|| {}
      url = url(params.delete(:repositoryId), params[:objectId])

      response = if params[:cmisaction]
        @http.post(url, params, headers)
      else
        @http.get(url, params.merge(query), headers)
      end

      response.body
    end

    private

    def url(repository_id, object_id)
      if repository_id.nil?
        @service_url
      else
        urls = repository_urls(repository_id)
        urls[object_id ? :root_folder_url : :repository_url]
      end
    end

    def repository_urls(repository_id)
      if @url_cache[repository_id].nil?
        repository_infos = @http.get(@service_url).body

        unless repository_infos.has_key?(repository_id)
          raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
        end

        repository_info = repository_infos[repository_id]
        @url_cache[repository_id] = {
          repository_url:  repository_info[:repositoryUrl],
          root_folder_url: repository_info[:rootFolderUrl]
        }
      end
      @url_cache[repository_id]
    end
  end

  class RequestModifier < Faraday::Middleware
    def call(env)
      if env[:body]
        env[:body].compact!
        wrap_content(env)
        massage_properties(env)
      end
      @app.call(env)
    end

    private

    def wrap_content(env)
      if content_hash = env[:body][:content]
        env[:body][:content] = Faraday::UploadIO.new(content_hash[:stream],
                                                     content_hash[:mime_type],
                                                     content_hash[:filename])
      end
    end

    def massage_properties(env)
      if props = env[:body].delete(:properties)
        props.each_with_index do |(id, value), index|
          if value.is_a?(Array)
            env[:body][id_key(index)] = id
            value.each_with_index do |sub_value, sub_index|
              env[:body][val_key(index, sub_index)] = normalize(sub_value)
            end
          else
            env[:body][id_key(index)] = id
            env[:body][val_key(index)] = normalize(value)
          end
        end
      end
    end

    def normalize(value)
      value = value.to_time if value.is_a?(Date)
      value = (value.to_f * 1000).to_i if value.is_a?(Time)
      value
    end

    def id_key(index)
      "propertyId[#{index}]"
    end

    def val_key(i1, i2 = nil)
      result = "propertyValue[#{i1}]"
      result = "#{result}[#{i2}]" if i2
      result
    end
  end

  class ResponseParser < Faraday::Middleware
    JSON_CONTENT_TYPE = /\/(x-)?json(;.+?)?$/

    def call(env)
      @app.call(env).on_complete do |env|
        if env[:response_headers][:content_type] =~ JSON_CONTENT_TYPE
          env[:body] = JSON.parse(env[:body]).with_indifferent_access
          check_for_exception!(env[:body])
        end
      end
    end

    private

    def check_for_exception!(body)
      return unless body.is_a?(Hash)

      if ex = body[:exception]
        ruby_exception = "CMIS::Exceptions::#{ex.camelize}".constantize
        message = "#{ex.underscore.humanize}: #{body[:message]}"
        raise ruby_exception, message
      end
    end
  end
end
