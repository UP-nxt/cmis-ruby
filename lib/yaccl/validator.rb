module YACCL
  module Validator
    def self.validate_and_fix_request(client, required, optional)
      checkers = YACCL::Validator.constants.map { |constant| YACCL::Validator.const_get(constant) }.select do |c|
        c.is_a?(Class) && c<YACCL::Validator::Checker
      end

      checkers.each do |checker_class|
        checker = checker_class.new
        checker.client = client
        if(!checker.valid?(required, optional))
          required, optional = checker.fix(required, optional)
        end
      end

      [required, optional]
    end

    class Checker
      attr_accessor :client

      def valid?(req, opt)
      end

      def fix(req, opt)
      end
    end

  end
end

require 'yaccl/validators/type_property_checker'
require 'yaccl/validators/type_checker_boolean'
require 'yaccl/validators/type_checker_property_definitions'