require_relative 'services'

module UpnxtStorageLibCmisRuby
  module Services
    class AclServices
      include Services

      def get_acl(repository_id, object_id, only_basic_permissions, extension={})
        required = {repositoryId: repository_id,
                    cmisselector: 'acl',
                    objectId: object_id,
                    onlyBasicPermissions: only_basic_permissions}
        @service.perform_request(required)
      end

      def apply_acl(repository_id, object_id, add_aces, remove_aces, acl_propagation, extension={})
        required = {repositoryId: repository_id,
                    cmisaction: 'applyACL',
                    objectId: object_id,
                    addACEs: add_aces,
                    removeACEs: remove_aces,
                    ACLPropagation: acl_propagation}
        @service.perform_request(required)
      end
    end
  end
end
