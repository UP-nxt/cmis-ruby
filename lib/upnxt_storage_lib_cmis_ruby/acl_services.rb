require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class AclServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

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
