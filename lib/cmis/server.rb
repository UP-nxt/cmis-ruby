require 'active_support/core_ext/hash/indifferent_access'

module CMIS
  class Server
    attr_reader :connection

    def initialize(options = {})
      options.stringify_keys!

      service_url = options['service_url'] || ENV['CMIS_BROWSER_URL']
      username    = options['username']    || ENV['CMIS_USER']
      password    = options['password']    || ENV['CMIS_PASSWORD']
      headers     = options['headers']     || {}

      raise "`service_url` must be set" unless service_url

      @connection = Connection.new(service_url, username, password, headers)
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
