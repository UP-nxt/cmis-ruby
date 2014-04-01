require 'core_ext/hash/keys'
require 'core_ext/string/as_ruby_property'

module CMIS
  class PropertyDefinition
    def initialize(hash = {})
      @hash = hash.stringify_keys
      @hash.each_key do |key|
        self.class.class_eval "def #{key.as_ruby_property};@hash['#{key}'];end"
        self.class.class_eval "def #{key.as_ruby_property}=(value);@hash['#{key}']=value;end"
      end
    end

    def readonly?
      updatability == 'readonly'
    end

    def oncreate?
      updatability == 'oncreate'
    end

    def readwrite?
      updatability == 'readwrite'
    end

    def to_hash
      @hash
    end
  end
end
