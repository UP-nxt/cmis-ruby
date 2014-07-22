module CMIS
  class Server
    def initialize(options = {})
      @options = options.symbolize_keys
    end

    def connection
      @connection ||= Connection.new(@options)
    end

    def execute!(params = {}, options = {})
      params.symbolize_keys!

      options.symbolize_keys!
      query = options.fetch(:query, {})
      headers = options.fetch(:headers, {})

      connection.do_request(params, query, headers).body
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

    def inspect
      "#{self.class}[#{@options[:service_url]}]"
    end

    private

    def marshal_dump
      @options
    end

    def marshal_load(options)
      @options = options
    end
  end
end
