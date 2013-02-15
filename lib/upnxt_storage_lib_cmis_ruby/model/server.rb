require_relative 'services'
require_relative 'repository'

module Model
  class Server
    def self.repositories
      Services.repository.get_repositories.values.map do |repository|
        Repository.create(repository)
      end
    end

    def self.repository(repository_id)
      Repository.create(Services.repository.get_repository_info(repository_id).values.first)
    end
  end
end