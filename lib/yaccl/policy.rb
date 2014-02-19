module YACCL
  class Policy < Object

    attr_reader :policy_text

    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:policyText )
    end

    def apply_to(object)
      connection.execute!({ cmisaction: 'applyPolicy',
                            repositoryId: repository_id,
                            policyId: cmis_object_id,
                            objectId: object.cmis_object_id })
    end

    def remove_from(object)
      connection.execute!({ cmisaction: 'removePolicy',
                            repositoryId: repository_id,
                            policyId: cmis_object_id,
                            objectId: object.cmis_object_id })
    end

  end
end
