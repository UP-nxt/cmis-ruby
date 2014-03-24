require 'bigdecimal'
require 'cmis/query_result'
require 'core_ext/hash/keys'
require 'core_ext/hash/slice'

module CMIS
  class Query
    # Options: from, page_size
    def initialize(repository, statement, options = {})
      @repository = repository
      @statement = statement
      @options = options.symbolize_keys

      init_options
    end

    # Options: limit
    def each_result(options = {}, &block)
      return enum_for(:each_result, options) unless block_given?

      init_options
      limit = parse_limit(options)
      counter = 0

      while has_next?
        results.each do |object|
          break unless counter < limit
          yield object
          counter = counter.next
        end
      end
    end

    # Options: limit
    def each_page(options = {}, &block)
      return enum_for(:each_page, options) unless block_given?

      init_options
      limit = parse_limit(options)
      counter = 0

      while has_next?
        break unless counter < limit
        yield r = results
        counter += r.size
      end
    end

    def results
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
      @method = (@options[:method] || 'get').to_s.downcase
      @max_items = @options[:page_size] || 10
      @skip_count = @options[:from] || 0
      @has_next = true

      @opts = @options.slice(:query, :headers)
    end

    def parse_limit(options)
      options.symbolize_keys!
      limit = options[:limit] || 10
      limit = BigDecimal::INFINITY if limit == :all
      raise 'Not a valid limit' unless limit.is_a? Numeric
      limit
    end

    def do_query
      params = { repositoryId: @repository.id,
                 maxItems: @max_items,
                 skipCount: @skip_count }
      if @method == 'post'
        params.merge!(cmisselector: 'query', q: @statement)
      else
        params.merge!(cmisaction: 'query', statement: @statement)
      end

      result = @repository.server.execute!(params, @opts)

      results = result['results'].map do |r|
        ObjectFactory.create(r, @repository)
      end

      QueryResult.new(results, result['numItems'], result['hasMoreItems'])
    end
  end
end
