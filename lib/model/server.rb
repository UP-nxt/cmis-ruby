require_relative 'services'

class Server
    def self.repositories
        Services.repository.get_repository_infos.map do |repository|
            Repository.create(repository)
        end
    end

    def self.repository(repository_id)
        Respository.create(Services.repository.get_repository_info(repository_id))
    end
end