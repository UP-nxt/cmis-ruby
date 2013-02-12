require 'upnxt_storage_lib_cmis_ruby'

class Services

    def self.repository
        UpnxtStorageLibCmisRuby::RepositoryServices.new
    end

    def self.navigation
        UpnxtStorageLibCmisRuby::NavigationServices.new
    end

    def self.object
        UpnxtStorageLibCmisRuby::ObjectServices.new
    end

    def self.multi_filing
        UpnxtStorageLibCmisRuby::MultiFilingServices.new
    end

    def self.discovery
        UpnxtStorageLibCmisRuby::DiscoveryServices.new
    end

    def self.versioning
        UpnxtStorageLibCmisRuby::VersioningServices.new
    end

    def self.relationship
        UpnxtStorageLibCmisRuby::RelationshipServices.new
    end

    def self.policy
        UpnxtStorageLibCmisRuby::PolicyServices.new
    end

    def self.acl
        UpnxtStorageLibCmisRuby::AclServices.new
    end
end