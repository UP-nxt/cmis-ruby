require 'faraday'
require 'json'

module CMIS
  class Connection
    class ResponseParser < Faraday::Middleware
      JSON_CONTENT_TYPE = /\/(x-)?json(;.+?)?$/i.freeze
      HTML_CONTENT_TYPE = /text\/(x?)html/i.freeze

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

        if ex = body[:exception]
          ruby_exception = "CMIS::Exceptions::#{ex.camelize}".constantize
          message = "#{ex.underscore.humanize}: #{body[:message]}"
          raise ruby_exception, message
        end
      end
    end
  end
end
