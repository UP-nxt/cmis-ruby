module YACCL
  class Query

    # Options: from, fetch_size
    def initialize(repository, statement, options = {})
      @repository = repository
      @statement = statement
      @options = options.stringify_keys

      init_options
    end

    # Options: limit
    def each_result(options = {}, &block)
      return enum_for(:each_result, options) unless block_given?

      init_options
      limit = parse_limit(options)
      counter = 0

      while has_next?
        next_results.each do |object|
          break unless counter < limit
          yield object
          counter = counter.next
        end
      end
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

    def init_options
      @max_items = @options['fetch_size'] || 10
      @skip_count = @options['from'] || 0
      @has_next = true
    end

    def parse_limit(options)
      options.stringify_keys!
      limit = options['limit'] || 10
      limit = BigDecimal::INFINITY if limit == :all
      raise 'Not a valid limit' unless limit.is_a? Numeric
      limit
    end

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
