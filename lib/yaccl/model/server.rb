module YACCL
  module Model
    class Server
      def self.repositories
        Services.get_repositories.values.map { |r| Repository.create(r) }
      end

      def self.repository(repository_id)
        Repository.create(Services.get_repository_info(repository_id).values.first)
      end
    end
  end
end
