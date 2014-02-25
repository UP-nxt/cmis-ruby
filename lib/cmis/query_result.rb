module CMIS
  class QueryResult
    attr_reader :results
    attr_reader :num_items
    attr_reader :has_more_items

    def initialize(results, num_items, has_more_items)
      @results = results
      @num_items = num_items
      @has_more_items = has_more_items
    end
  end
end
