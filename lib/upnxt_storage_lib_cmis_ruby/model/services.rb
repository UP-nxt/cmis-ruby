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
      UpnxtStorageLibCmisRuby::RepositoryServices.new url
    end

    def self.navigation
      UpnxtStorageLibCmisRuby::NavigationServices.new url
    end

    def self.object
      UpnxtStorageLibCmisRuby::ObjectServices.new url
    end

    def self.multi_filing
      UpnxtStorageLibCmisRuby::MultiFilingServices.new url
    end

    def self.discovery
      UpnxtStorageLibCmisRuby::DiscoveryServices.new url
    end

    def self.versioning
      UpnxtStorageLibCmisRuby::VersioningServices.new url
    end

    def self.relationship
      UpnxtStorageLibCmisRuby::RelationshipServices.new url
    end

    def self.policy
      UpnxtStorageLibCmisRuby::PolicyServices.new url
    end

    def self.acl
      UpnxtStorageLibCmisRuby::AclServices.new url
    end
  end
end