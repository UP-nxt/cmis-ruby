module CMIS
  module Utils
    module_function

    def build_query_statement(type_id, properties)
      QueryStatementBuilder.new(type_id, properties).build
    end

    class QueryStatementBuilder
      def initialize(type_id, properties)
        @type_id = type_id
        @properties = properties
      end

      def build
        statement = "select * from #{@type_id}"
        clause = @properties.map { |k, v| "#{k}=#{normalize(v)}" }.join(' and ')
        statement << " where #{clause}" unless clause.empty?
        statement
      end

      private

      def normalize(value)
        if value.respond_to?(:strftime)
          value = value.strftime('%Y-%m-%dT%H:%M:%S.%L')
          "TIMESTAMP '#{value}'"
        else
          value = value.to_s
          value.gsub!(/\\/, Regexp.escape('\\\\'))
          value.gsub!(/'/, Regexp.escape('\\\''))
          "'#{value}'"
        end
      end
    end
  end
end
