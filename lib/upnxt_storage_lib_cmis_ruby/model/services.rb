require 'upnxt_storage_lib_cmis_ruby'

module Model
  class Services

    @@url = 'http://localhost:8080/upncmis/browser'

    def self.url
      @@url
    end

    def self.url=(url)
      @@url = url
    end

    def self.repository
      UpnxtStorageLibCmisRuby::Services::RepositoryServices.new url
    end

    def self.navigation
      UpnxtStorageLibCmisRuby::Services::NavigationServices.new url
    end

    def self.object
      UpnxtStorageLibCmisRuby::Services::ObjectServices.new url
    end

    def self.multi_filing
      UpnxtStorageLibCmisRuby::Services::MultiFilingServices.new url
    end

    def self.discovery
      UpnxtStorageLibCmisRuby::Services::DiscoveryServices.new url
    end

    def self.versioning
      UpnxtStorageLibCmisRuby::Services::VersioningServices.new url
    end

    def self.relationship
      UpnxtStorageLibCmisRuby::Services::RelationshipServices.new url
    end

    def self.policy
      UpnxtStorageLibCmisRuby::Services::PolicyServices.new url
    end

    def self.acl
      UpnxtStorageLibCmisRuby::Services::AclServices.new url
    end
  end
end