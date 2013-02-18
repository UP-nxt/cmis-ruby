module YACCL
  module Model
    class Service
      def self.repositories
        Services.get_repositories.values.map do |repository|
          Repository.create(repository)
        end
      end

      def self.repository(repository_id)
        Repository.create(Services.get_repository_info(repository_id).values.first)
      end
    end
  end
end
