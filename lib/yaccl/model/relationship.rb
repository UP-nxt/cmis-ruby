module YACCL
  module Model
    class Relationship < Object
      attr_reader :source_id
      attr_reader :target_id

      def initialize(repository_id, raw={})
        super
        @source_id = @properties[:'cmis:sourceId']
        @target_id = @properties[:'cmis:targetId']
      end

      def source
        ObjectFactory.create(repository_id, Services.get_object(repository_id, source_id, nil, false, nil, nil, false, false))
      end

      def target
        ObjectFactory.create(repository_id, Services.get_object(repository_id, target_id, nil, false, nil, nil, false, false))
      end

      def method_missing(method_sym, *arguments, &block)
        return @properties[method_sym] if @properties[method_sym]
        return @properties[method_sym.to_s] if @properties[method_sym.to_s]
        super
      end
    end
  end
end
