module CMIS
  class Connection
    class URLResolver
      def initialize(http, service_url)
        @http = http
        @service_url = service_url
        @repository_infos = {}
      end

      def url(repository_id, object_id)
        return @service_url unless repository_id

        unless @repository_infos.key?(repository_id)
          @repository_infos = @http.get(@service_url).body
        end

        if @repository_infos.key?(repository_id)
          key = object_id ? 'rootFolderUrl' : 'repositoryUrl'
          @repository_infos[repository_id][key]
        else
          raise Exceptions::ObjectNotFound, "repositoryId: #{repository_id}"
        end
      end
    end
  end
end
