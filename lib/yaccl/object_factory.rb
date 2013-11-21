module YACCL
  module Model
    class ObjectFactory
      def self.create(raw, repository_id = nil, client = nil)
        base_type_id = if raw[:properties]
          raw[:properties][:'cmis:baseTypeId'][:value]
        elsif raw[:succinctProperties]
          raw[:succinctProperties][:'cmis:baseTypeId']
        else
          raise "Unexpected raw: #{raw}"
        end
        
        properties = raw[:succinctProperties]
        o = nil
        case base_type_id
        when 'cmis:folder' then o = Folder.create(properties)
        when 'cmis:document' then o = Document.create(properties)
        when 'cmis:relationship' then o = Relationship.create(properties)
        when 'cmis:policy' then o = Policy.create(properties)
        when 'cmis:item' then o = Item.create(properties)
        else raise "Unexpected baseTypeId: #{base_type_id}."
        end
        o.client = client
        o.repository_id = repository_id

        o.allowable_actions = raw[:allowableActions] if raw.has_key?(:allowableActions) && raw[:allowableActions]
        o.acl = raw[:acl] if raw.has_key?(:acl) && raw[:acl]
        o.exact_acl = raw[:exactACL] if raw.has_key?(:exactACL) && raw[:exactACL]
        o.policy_ids = raw[:policyIds][:ids] if raw.has_key?(:policyIds) && raw[:policyIds].has_key?(:ids)

        o
      end
    end
  end
end
