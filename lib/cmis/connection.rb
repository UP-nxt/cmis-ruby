require 'cmis/connection/request_modifier'
require 'cmis/connection/response_parser'
require 'cmis/connection/url_resolver'
require 'cmis/version'
require 'faraday'

module CMIS
  class Connection
    def initialize(options)
      options.symbolize_keys!

      message = "option `service_url` must be set"
      service_url = options[:service_url] or raise message

      options[:adapter] ||= :net_http

      @http = Faraday.new(connection_options(options)) do |builder|
        builder.use RequestModifier
        builder.request :multipart
        builder.request :url_encoded

        if options[:username]
          builder.basic_auth(options[:username], options[:password])
        end

        builder.adapter options[:adapter].to_sym
        builder.response :logger if options[:log_requests]
        builder.use ResponseParser
      end

      @url_resolver = URLResolver.new(@http, service_url)
    end

    def execute!(params = {}, options = {})
      params.symbolize_keys!
      options.symbolize_keys!

      query = options.fetch(:query, {})
      headers = options.fetch(:headers, {})
      url = @url_resolver.url(params.delete(:repositoryId), params[:objectId])

      response = if params[:cmisaction]
        @http.post(url, params, headers)
      else
        @http.get(url, params.merge(query), headers)
      end

      response.body
    end

    private

    def connection_options(options)
      headers = { user_agent: "cmis-ruby/#{VERSION} [#{options[:adapter]}]" }
      headers.merge!(options[:headers]) if options[:headers]

      conn_opts = { headers: headers }
      conn_opts[:ssl] = options[:ssl] if options[:ssl]

      conn_opts
    end
  end
end
