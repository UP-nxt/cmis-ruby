module CMIS
  class QueryResult
    attr_reader :results
    attr_reader :num_items
    attr_reader :has_more_items
    attr_reader :debug_info

    def initialize(results, num_items, has_more_items, debug_info=nil)
      @results = results
      @num_items = num_items
      @has_more_items = has_more_items
      @debug_info = debug_info
    end
  end
end
