require 'faraday'
require 'json'

module CMIS
  class Connection
    class ResponseParser < Faraday::Middleware
      JSON_CONTENT_TYPE = /\/(x-)?json(;.+?)?$/i.freeze

      def call(env)
        response = @app.call(env)

        response.on_complete do |env|

          # Remove Authorization header when following redirects
          # This hack should be removed when issue #81 is merged
          # Cf. https://github.com/lostisland/faraday_middleware/pull/81
          if [301, 302, 303, 307].include?(response.status)
            env[:request_headers].delete('Authorization')
          end

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

        if body.key?('exception')
          e, m, s = body.values_at('exception', 'message', 'stacktrace')
          raise exception_class(e), "[#{e}] #{m}\n#{s}"
        end
      end

      def exception_class(exception)
        clazz = exception.dup
        clazz[0] = clazz[0].upcase
        CMIS::Exceptions.const_get(clazz) rescue Exception
      end
    end
  end
end
