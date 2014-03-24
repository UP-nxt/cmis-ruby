require 'core_ext/array/indifferent_access'
require 'core_ext/hash/indifferent_access'
require 'faraday'
require 'json'

module CMIS
  class Connection
    class ResponseParser < Faraday::Middleware
      JSON_CONTENT_TYPE = /\/(x-)?json(;.+?)?$/i.freeze

      def call(env)
        @app.call(env).on_complete do |env|
          case env[:status]
          when 401
            raise Exceptions::Unauthorized
          else
            if env[:response_headers][:content_type] =~ JSON_CONTENT_TYPE
              env[:body] = JSON.parse(env[:body]).with_indifferent_access
              check_for_cmis_exception!(env[:body])
            end
          end
        end
      end

      private

      def check_for_cmis_exception!(body)
        return unless body.is_a?(Hash)

        if exception = body[:exception]
          raise exception_class(exception), "#{exception}: #{body[:message]}"
        end
      end

      def exception_class(exception)
        clazz = exception.dup
        clazz[0] = clazz[0].upcase
        Object.const_get("CMIS::Exceptions::#{clazz}")
      end
    end
  end
end
