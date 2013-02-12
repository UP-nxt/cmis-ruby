require_relative 'services'

class Server
    def repositories
        Services.repository.get_repository_infos.map do |repository|
            Repository.create(repository)
        end
    end
end