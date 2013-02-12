require_relative 'services'

class Policy < Object
    attr_reader :policy_text

    def apply_to(object)
        Services.policy.apply_policy(repository_id, object_id, object.object_id)
    end

    def remove_from(object)
        Services.policy.remove_policy(repository_id, object_id, object.object_id)
    end
end