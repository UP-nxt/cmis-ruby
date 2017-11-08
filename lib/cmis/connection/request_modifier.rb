require 'faraday'
require 'date'

module CMIS
  class Connection
    class RequestModifier < Faraday::Middleware
      def call(env)
        if env[:body]
          env[:body].reject! { |_, v| v.nil? }
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

        if tuples = env[:body].delete(:objectIdAndChangeToken)
          tuples.each_with_index do |(object_id, change_token), index|
            env[:body]["objectId[#{index}]"] = object_id
            env[:body]["changeToken[#{index}]"] = change_token
          end
        end
      end

      def normalize(v)
        v = Time.parse(v.to_s).utc if v.is_a?(Date)
        v = (v.to_f * 1000).to_i if v.is_a?(Time)
        v
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
