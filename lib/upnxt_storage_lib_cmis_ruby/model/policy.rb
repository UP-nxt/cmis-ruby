module UpnxtStorageLibCmisRuby
  module Model
    class Policy < Object
      attr_reader :policy_text

      def initialize(repository_id, raw={})
        super
        @policy_text = @properties[:'cmis:policyText']
      end

      def apply_to(object)
        UpnxtStorageLibCmisRuby::Services.policy.apply_policy(repository_id, object_id, object.object_id)
      end

      def remove_from(object)
        UpnxtStorageLibCmisRuby::Services.policy.remove_policy(repository_id, object_id, object.object_id)
      end
    end
  end
end
