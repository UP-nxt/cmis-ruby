module CMIS
  class Server
    attr_reader :connection

    def initialize(options = {})
      @connection = Connection.new(options)
    end

    def repositories(opts = {})
      result = connection.execute!({}, opts)

      result.values.map do |r|
        Repository.new(r, connection)
      end
    end

    def repository(repository_id, opts = {})
      result = connection.execute!({ cmisselector: 'repositoryInfo',
                                     repositoryId: repository_id }, opts)

      Repository.new(result[repository_id], connection)
    end

    def has_repository?(repository_id)
      repository(repository_id)
      true
    rescue Exceptions::ObjectNotFound
      false
    end
  end
end
