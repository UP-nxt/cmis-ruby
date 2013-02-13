require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  module BrowserBindingService
    include HTTParty
    base_uri 'http://localhost:8080/upncmis/browser'
    parser Proc.new { |body| MultiJson.load(body, symbolize_keys: true) }

    def self.multipart_post(path, options={})
      url = URI.parse("#{base_uri}#{path}")
      req = Net::HTTP::Post::Multipart.new(url.path, options[:body])
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      MultiJson.load(res.body, symbolize_keys: true)
    end
  end
end

module Multipartable
  alias_method :__initialize__, :initialize

  def initialize(path, params, headers={}, boundary=DEFAULT_BOUNDARY)
    __initialize__(path, create_properties_controls(params), headers, boundary)
  end

  private
  
  def create_properties_controls(params)
    # TODO Make this work for multi-valued properties
    new_params = {}
    params.each do |key, value|
      if key.to_sym == :properties
        value.each_with_index do |(property_id, property_value), i|
          new_params["propertyId[#{i}]"] = property_id
          new_params["propertyValue[#{i}]"] = property_value
        end
      else
        new_params[key] = value
      end
    end
    new_params
  end
end
