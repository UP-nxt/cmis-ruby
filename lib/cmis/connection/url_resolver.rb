module CMIS
  class Connection
    class URLResolver
      def initialize(http, service_url)
        @http = http
        @service_url = service_url
        @infos = {}
      end

      def url(repository_id, object_id)
        return @service_url unless repository_id

        @infos = @http.get(@service_url).body unless @infos.key?(repository_id)

        if @infos.key?(repository_id)
          @infos[repository_id][object_id ? 'rootFolderUrl' : 'repositoryUrl']
        else
          raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
        end
      end
    end
  end
end
