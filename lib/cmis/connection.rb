require 'cmis/connection/url_resolver'
require 'cmis/connection/request_modifier'
require 'cmis/connection/response_parser'

module CMIS
  class Connection
    def initialize(options)
      options.symbolize_keys!

      message = "option `service_url` must be set"
      service_url = options[:service_url] or raise message

      adapter = (options[:adapter] || :net_http).to_sym

      headers = {
        user_agent: "cmis-ruby/#{VERSION} [#{adapter}]"
      }.merge(options[:headers] || {})
      conn_opts = { headers: headers, ssl: options[:ssl] }.compact

      @http = Faraday.new(conn_opts) do |builder|
        builder.use RequestModifier
        builder.request :multipart
        builder.request :url_encoded

        if options[:username]
          builder.basic_auth(options[:username], options[:password])
        end

        builder.adapter adapter
        builder.response :logger if options[:log_requests]
        builder.use ResponseParser
      end

      @url_resolver = URLResolver.new(@http, service_url)
    end

    def execute!(params = {}, options = {})
      options.symbolize_keys!

      query = options[:query] || {}
      headers = options[:headers] || {}
      url = @url_resolver.url(params.delete(:repositoryId), params[:objectId])

      response = if params[:cmisaction]
        @http.post(url, params, headers)
      else
        @http.get(url, params.merge(query), headers)
      end

      response.body
    end
  end
end
