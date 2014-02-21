module YACCL
  class Query

    def initialize(repository, statement, options)
      @repository = repository
      @statement = statement

      options.stringify_keys!
      @max_items = options['max_items'] || 10
      @skip_count = options['skip_count'] || 0

      @has_next = true
    end

    def next_results
      result = do_query

      @skip_count += result.results.size
      @has_next = result.has_more_items
      @total = result.num_items

      result.results
    end

    def has_next?
      @has_next
    end

    def total
      @total ||= do_query.num_items
    end

    private

    def do_query
      result = @repository.connection.execute!({ cmisselector: 'query',
                                                 repositoryId: @repository.id,
                                                 q: @statement,
                                                 maxItems: @max_items,
                                                 skipCount: @skip_count })

      results = result['results'].map do |r|
        ObjectFactory.create(r, @repository)
      end

      QueryResult.new(results, result['numItems'], result['hasMoreItems'])
    end

  end
end
