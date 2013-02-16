module UpnxtStorageLibCmisRuby
  module Model
    class Service
      def self.repositories
        UpnxtStorageLibCmisRuby::Services.repository.get_repositories.values.map do |repository|
          Repository.create(repository)
        end
      end

      def self.repository(repository_id)
        Repository.create(UpnxtStorageLibCmisRuby::Services.repository.get_repository_info(repository_id).values.first)
      end
    end
  end
end
