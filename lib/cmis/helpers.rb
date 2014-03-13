module CMIS
  module Helpers
    def initialize_properties(raw)
      @properties = get_properties_map(raw)
    end

    def cmis_properties(properties)
      properties.each do |property_name|
        method_name = method_name(property_name)
        class_eval "def #{method_name};@properties['#{property_name}'];end"
        class_eval "def #{method_name}=(value);@properties['#{property_name}']=value;end"
      end
    end

    def with_change_token(&block)
      json = yield
      if props = json['properties']
        self.change_token = props['cmis:changeToken']['value']
      elsif succinct_props = json['succinctProperties']
        self.change_token = succinct_props['cmis:changeToken']
      else
        raise "Unexpected input: #{json}"
      end
    end

    def self.respond_to?(name, include_private = false)
      if @properties.has_key?(name.to_s)
        true
      else
        super
      end
    end

    def method_missing(name, *args, &block)
      if @properties.has_key?(name.to_s)
        @properties[name.to_s]
      else
        super
      end
    end

    private

    def method_name(property_name)
      if property_name == 'cmis:objectId'
        'cmis_object_id'
      else
        property_name.gsub('cmis:', '').underscore
      end
    end

    def get_properties_map(raw)
      raw = raw.with_indifferent_access

      if raw['succinctProperties']
        result = raw['succinctProperties']
      elsif raw['properties']
        result = raw['properties'].reduce({}) do |h, (k, v)|
          h.merge(k => sanitize(v))
        end
      else
        result = {}
      end

      result.with_indifferent_access
    end

    def sanitize(prop)
      value = prop['value']

      # Sometimes (when?) single values come in an array
      if value.is_a?(Array) && prop['cardinality'] == 'single'
        value = value.first
      end

      if !!value && prop['type'] == 'datetime'
        # CMIS sends millis since epoch
        value = Time.at(value / 1000.0)
      end

      value
    end
  end
end
