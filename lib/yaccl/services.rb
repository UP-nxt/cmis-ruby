require 'yaccl/services/internal/browser_binding_service'
require 'yaccl/services/repository_services'
require 'yaccl/services/navigation_services'
require 'yaccl/services/object_services'
require 'yaccl/services/multi_filing_services'
require 'yaccl/services/discovery_services'
require 'yaccl/services/versioning_services'
require 'yaccl/services/relationship_services'
require 'yaccl/services/policy_services'
require 'yaccl/services/acl_services'

module YACCL
  module Services
    @service = Internal::BrowserBindingService.new('http://localhost:8080/upncmis/browser')

    class << self
      def perform_request(*params)
        @service.perform_request(*params)
      end

      include RepositoryServices
      include NavigationServices
      include ObjectServices
      include MultiFilingServices
      include DiscoveryServices
      include VersioningServices
      include RelationshipServices
      include PolicyServices
      include ACLServices
    end
  end
end
