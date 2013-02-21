module YACCL
  VERSION = '0.0.1'

  def self.init(url)
    YACCL.const_set('SERVICE_URL', url)
  end
end

require 'yaccl/model'
require 'yaccl/services'
