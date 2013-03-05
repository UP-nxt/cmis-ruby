module YACCL
  def self.init(service_url, basic_auth_username=nil, basic_auth_password=nil)
    YACCL.const_set('SERVICE_URL', service_url)
    YACCL.const_set('BASIC_AUTH_USERNAME', basic_auth_username)
    YACCL.const_set('BASIC_AUTH_PASSWORD', basic_auth_password)
  end
end

require 'yaccl/model'
require 'yaccl/services'
