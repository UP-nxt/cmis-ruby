module UpnxtStorageLibCmisRuby
  module Services
    @@url = 'http://localhost:8080/upncmis/browser'

    def self.url
      @@url
    end

    def self.url=(url)
      @@url = url
    end

    def self.repository
      RepositoryServices.new(url)
    end

    def self.navigation
      NavigationServices.new(url)
    end

    def self.object
      ObjectServices.new(url)
    end

    def self.multi_filing
      MultiFilingServices.new(url)
    end

    def self.discovery
      DiscoveryServices.new(url)
    end

    def self.versioning
      VersioningServices.new(url)
    end

    def self.relationship
      RelationshipServices.new(url)
    end

    def self.policy
      PolicyServices.new(url)
    end

    def self.acl
      AclServices.new(url)
    end
  end
end
