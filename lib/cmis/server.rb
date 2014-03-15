module CMIS
  class Server < Connection
    def initialize(options = {})
      super
    end

    def repositories(opts = {})
      result = execute!({}, opts)

      result.values.map do |r|
        Repository.new(r, self)
      end
    end

    def repository(repository_id, opts = {})
      result = execute!({ cmisselector: 'repositoryInfo',
                          repositoryId: repository_id }, opts)

      Repository.new(result[repository_id], self)
    end

    def repository?(repository_id)
      repository(repository_id)
      true
    rescue Exceptions::ObjectNotFound
      false
    end
  end
end
