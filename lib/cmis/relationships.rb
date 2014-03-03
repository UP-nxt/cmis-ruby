require 'active_support/core_ext/hash/slice'

module CMIS
  class Relationships
    # Options: from, page_size
    def initialize(object, options = {})
      @object = object
      @options = options.stringify_keys!

      init_options
    end

    # Options: limit
    def each_relationship(options = {}, &block)
      return enum_for(:each_relationship, options) unless block_given?

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
      result = do_get_relationships

      @skip_count += result.results.size
      @has_next = result.has_more_items
      @total = result.num_items

      result.results
    end

    def has_next?
      @has_next
    end

    def total
      @total ||= do_get_relationships.num_items
    end

    private

    def init_options
      @max_items = @options['page_size'] || 10
      @skip_count = @options['from'] || 0
      @direction = @options['direction'] || :either
      @include_subtypes = @options['include_subtypes']
      @type_id = @options['type_id']
      @has_next = true

      @opts = @options.slice('query', 'headers')
    end

    def parse_limit(options)
      options.stringify_keys!
      limit = options['limit'] || 10
      limit = BigDecimal::INFINITY if limit == :all
      raise 'Not a valid limit' unless limit.is_a? Numeric
      limit
    end

    def do_get_relationships
      connection = @object.repository.connection
      result = connection.execute!({ cmisselector: 'relationships',
                                     repositoryId: @object.repository.id,
                                     objectId: @object.cmis_object_id,
                                     maxItems: @max_items,
                                     skipCount: @skip_count,
                                     relationshipDirection: @direction,
                                     includeSubRelationshipTypes: @include_subtypes,
                                     typeId: @type_id }, @opts)

      results = result['objects'].map do |r|
        ObjectFactory.create(r, @object.repository)
      end

      QueryResult.new(results, result['numItems'], result['hasMoreItems'])
    end
  end
end
