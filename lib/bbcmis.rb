require 'httparty'
require 'multi_json'

module BBCMIS

  class ClassMethods

    def self.get_repositories
      Service.get('')
    end

    def self.get_repository_info(repository_id)
      params = {
        cmisselector: 'repositoryInfo'
      }
      Service.get("/#{repository_id}", query: params)
    end

    def self.get_type_children(repository_id, type_id)
      params = {
        cmisselector: 'typeChildren',
        typeId: type_id,
        includePropertyDefinitions: true,
        # maxItems: 100,
        # skipCount: 0
      }
      Service.get("/#{repository_id}", query: params)
    end

  end

  class Service
    include HTTParty
    base_uri 'http://localhost:8080/upncmis/browser'
    parser Proc.new { |body, format| MultiJson.load(body, symbolize_keys: true) }
  end

end

# require 'pp'
# pp BBCMIS::ClassMethods.get_type_children('blueprint', 'cmis:folder')
