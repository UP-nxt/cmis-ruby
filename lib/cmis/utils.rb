module CMIS
  module Utils
    module_function

    def build_query_statement(type_id, properties, *queried_properties)
      QueryStatementBuilder.new(type_id, properties, queried_properties).build
    end

    class QueryStatementBuilder
      def initialize(type_id, properties, queried_properties)
        @type_id = type_id
        @properties = properties
        @queried_properties = Array(queried_properties).join(', ')
        @queried_properties = '*' if @queried_properties.empty?
      end

      def build
        statement = "select #{@queried_properties} from #{@type_id}"
        clause = @properties.map { |k, v| build_predicate(k, v) }.join(' and ')
        statement << " where #{clause}" unless clause.empty?
        statement
      end

      private

      MAP = {
        '_eq'     => ' =',
        '_not_eq' => ' <>',
        '_lt'     => ' <',
        '_lteq'   => ' <=',
        '_gt'     => ' >',
        '_gteq'   => ' >=',
        '_eqany'  => ''
      }
      def build_predicate(k, v)
        key = k.to_s.dup
        key << '_eq' unless key.end_with?(*MAP.keys)
        if key.end_with?('_eq') && v.nil?
          "#{key[0..-4]} is null"
        elsif key.end_with?('_eqany')
          value = normalize(v)
          "#{value} = ANY #{key[0..-7]}"
        else
          value = normalize(v)
          re = Regexp.new(MAP.keys.map { |x| Regexp.escape(x) + '$' }.join('|'))
          [key.gsub(re, MAP), value].join(' ')
        end
      end

      def normalize(value)
        if value.respond_to?(:strftime) # datetime literal
          value = value.strftime('%Y-%m-%dT%H:%M:%S.%L')
          "TIMESTAMP '#{value}'"

        elsif value.is_a?(Numeric) # signed numeric literal
          value

        elsif value.is_a?(TrueClass) || value.is_a?(FalseClass) # boolean literal
          value

        else # treat as a character string literal
          value = value.to_s.dup
          value.gsub!(/\\/, Regexp.escape('\\\\'))
          value.gsub!(/'/, Regexp.escape('\\\''))
          "'#{value}'"
        end
      end
    end
  end
end
