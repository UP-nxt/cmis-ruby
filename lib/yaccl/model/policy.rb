module YACCL
  module Model
    class Policy < Object
      attr_reader :policy_text

      def initialize(repository_id, raw={})
        super
        @policy_text = @properties[:'cmis:policyText']
      end

      def apply_to(object)
        Services.apply_policy(repository_id, object_id, object.object_id)
      end

      def remove_from(object)
        Services.remove_policy(repository_id, object_id, object.object_id)
      end
    end
  end
end
