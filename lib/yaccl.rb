module YACCL
  def self.init(service_url, basic_auth_username=nil, basic_auth_password=nil, succint_properties=true)
    YACCL.const_set('SERVICE_URL', service_url)
    YACCL.const_set('BASIC_AUTH_USERNAME', basic_auth_username)
    YACCL.const_set('BASIC_AUTH_PASSWORD', basic_auth_password)
    YACCL.const_set('SUCCINCT_PROPERTIES', succint_properties)
  end
end

require 'yaccl/model'
require 'yaccl/services'
