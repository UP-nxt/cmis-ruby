require_relative 'services'

module Model
  class Policy < Object
    def self.create(raw)
      Policy.new(raw)
    end

    attr_reader :policy_text

    def initialize(raw)
      super(raw)
      @policy_text = raw[:'cmis:policyText']
    end

    def apply_to(object)
      Services.policy.apply_policy(repository_id, object_id, object.object_id)
    end

    def remove_from(object)
      Services.policy.remove_policy(repository_id, object_id, object.object_id)
    end
  end
end