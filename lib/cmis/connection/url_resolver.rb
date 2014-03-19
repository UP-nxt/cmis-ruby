module CMIS
  class Connection
    class URLResolver
      def initialize(http, service_url)
        @http = http
        @service_url = service_url
        @cache = {}
      end

      def url(repository_id, object_id)
        return @service_url if repository_id.nil?

        urls = repository_urls(repository_id)
        urls[object_id ? :root_folder_url : :repository_url]
      end

      private

      def repository_urls(repository_id)
        if @cache[repository_id].nil?
          repository_infos = @http.get(@service_url).body

          unless repository_infos.has_key?(repository_id)
            raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
          end

          repository_info = repository_infos[repository_id]
          @cache[repository_id] = {
            repository_url:  repository_info[:repositoryUrl],
            root_folder_url: repository_info[:rootFolderUrl]
          }
        end

        @cache[repository_id]
      end
    end
  end
end
