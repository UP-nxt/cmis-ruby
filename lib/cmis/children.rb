module CMIS
  class Children

    def initialize(folder, options)
      options.stringify_keys!

      @folder = folder
      @repository = folder.repository
      @connection = folder.repository.connection

      @max_items = options['max_items'] || 10
      @skip_count = options['skip_count'] || 0
      @order_by = options['order_by']

      @has_next = true
    end

    def next_results
      result = do_get_children

      @skip_count += result.results.size
      @has_next = result.has_more_items
      @total = result.num_items

      result.results
    end

    def has_next?
      @has_next
    end

    def total
      @total ||= do_get_children.num_items
    end

    private

    def do_get_children
      result = @connection.execute!({ cmisselector: 'children',
                                      repositoryId: @repository.id,
                                      objectId: @folder.cmis_object_id,
                                      maxItems: @max_items,
                                      skipCount: @skip_count,
                                      orderBy: @order_by })

      results = result['objects'].map do |r|
        ObjectFactory.create(r['object'], @repository)
      end

      QueryResult.new(results, result['numItems'], result['hasMoreItems'])
    end

  end
end
