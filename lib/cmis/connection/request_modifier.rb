require 'faraday'

module CMIS
  class Connection
    class RequestModifier < Faraday::Middleware
      def call(env)
        if env[:body]
          env[:body].compact!
          wrap_content(env)
          massage_properties(env)
        end
        @app.call(env)
      end

      private

      def wrap_content(env)
        if content_hash = env[:body][:content]
          env[:body][:content] = Faraday::UploadIO.new(content_hash[:stream],
                                                       content_hash[:mime_type],
                                                       content_hash[:filename])
        end
      end

      def massage_properties(env)
        if props = env[:body].delete(:properties)
          props.each_with_index do |(id, value), index|
            if value.is_a?(Array)
              env[:body][id_key(index)] = id
              value.each_with_index do |sub_value, sub_index|
                env[:body][val_key(index, sub_index)] = normalize(sub_value)
              end
            else
              env[:body][id_key(index)] = id
              env[:body][val_key(index)] = normalize(value)
            end
          end
        end
      end

      def normalize(value)
        value = value.to_time if value.is_a?(Date)
        value = (value.to_f * 1000).to_i if value.is_a?(Time)
        value
      end

      def id_key(index)
        "propertyId[#{index}]"
      end

      def val_key(i1, i2 = nil)
        result = "propertyValue[#{i1}]"
        result = "#{result}[#{i2}]" if i2
        result
      end
    end
  end
end
