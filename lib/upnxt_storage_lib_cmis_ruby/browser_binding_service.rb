require 'httparty'
require 'net/http/post/multipart'
require 'multi_json'

module UpnxtStorageLibCmisRuby
  module BrowserBindingService

    include HTTParty
    base_uri 'http://localhost:8080/upncmis/browser'

    def self.multipart_post(path, opts)
      lines = {}
      opts[:body].each do |k, v|
        if k == :properties
          v.each_with_index do |(p_id, p_value), i|
            lines["propertyId[#{i}]"] = p_id
            lines["propertyValue[#{i}]"] = p_value
          end
        else
          lines[k] = v unless v.nil?
        end
      end
      url = URI.parse("http://localhost:8080/upncmis/browser#{path}")
      req = Net::HTTP::Post::Multipart.new url.path, lines
      Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    end
  end
end
