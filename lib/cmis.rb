require 'ext/hash/except'
require 'ext/hash/keys'
require 'ext/hash/slice'
require 'ext/string/as_ruby_property'

require 'cmis/exceptions'
require 'cmis/helpers'
require 'cmis/object_factory'
require 'cmis/connection'
require 'cmis/server'
require 'cmis/repository'
require 'cmis/object'
require 'cmis/document'
require 'cmis/folder'
require 'cmis/item'
require 'cmis/policy'
require 'cmis/relationship'
require 'cmis/type'
require 'cmis/property_definition'

# Faraday doesn't allow to set the content type
# of param parts of multipart posts
module Parts
  class ParamPart
    alias_method :old_initialize, :initialize
    def initialize(boundary, name, value, headers = {})
      headers.merge!('Content-Type' => 'text/plain; charset=utf-8')
      old_initialize(boundary, name, value, headers)
    end
  end
end
