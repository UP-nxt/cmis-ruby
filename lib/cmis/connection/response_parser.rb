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
              parse_body(env)
              check_for_cmis_exception!(env[:body])
            end
          end
        end
      end

      private

      def parse_body(env)
        unless env[:response_headers][:content_disposition]
          env[:body] = JSON.parse(env[:body])
        end
      end

      def check_for_cmis_exception!(body)
        return unless body.is_a?(Hash)

        if exception = body['exception']
          raise exception_class(exception), "#{exception}: #{body['message']}"
        end
      end

      def exception_class(exception)
        clazz = exception.dup
        clazz[0] = clazz[0].upcase
        CMIS::Exceptions.const_get(clazz)
      end
    end
  end
end
