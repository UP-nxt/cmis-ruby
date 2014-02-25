module CMIS
  class Policy < Object
    attr_reader :policy_text

    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:policyText )
    end

    def apply_to(object, opts = {})
      connection.execute!({ cmisaction: 'applyPolicy',
                            repositoryId: repository_id,
                            policyId: cmis_object_id,
                            objectId: object.cmis_object_id }, opts)
    end

    def remove_from(object, opts = {})
      connection.execute!({ cmisaction: 'removePolicy',
                            repositoryId: repository_id,
                            policyId: cmis_object_id,
                            objectId: object.cmis_object_id }, opts)
    end
  end
end
