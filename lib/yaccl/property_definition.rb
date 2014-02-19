require 'active_support/core_ext'

module YACCL
  class PropertyDefinition

    def initialize(hash = {})
      @hash = hash.with_indifferent_access

      @hash.each_key do |key|
        class_eval "def #{key.underscore};@hash['#{key}'];end"
        class_eval "def #{key.underscore}=(value);@hash['#{key}']=value;end"
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
