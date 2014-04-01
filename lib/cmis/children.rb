require 'bigdecimal'
require 'cmis/query_result'

module CMIS
  class Children
    # Options: from, page_size
    def initialize(folder, options = {})
      @folder = folder
      @options = options.symbolize_keys

      init_options
    end

    # Options: limit
    def each_child(options = {}, &block)
      return enum_for(:each_child, options) unless block_given?

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

    def init_options
      @max_items = @options[:page_size] || 10
      @skip_count = @options[:from] || 0
      @order_by = @options[:order_by]
      @filter = @options[:filter]
      @include_relationships = @options[:include_relationships]
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

    def do_get_children
      server = @folder.repository.server
      result = server.execute!({ cmisselector: 'children',
                                 repositoryId: @folder.repository.id,
                                 objectId: @folder.cmis_object_id,
                                 maxItems: @max_items,
                                 skipCount: @skip_count,
                                 orderBy: @order_by,
                                 includeRelationships: @include_relationships,
                                 filter: @filter }, @opts)

      results = result['objects'].map { |o| build_object_with_relationships(o) }
      QueryResult.new(results, result['numItems'], result['hasMoreItems'])
    end

    def build_object_with_relationships(json)
      object = ObjectFactory.create(json['object'], @folder.repository)

      # If relationships are included, override the object method...
      if relationships = build_relationships(json)
        metaclass = class << object; self; end
        metaclass.send(:define_method, :relationships) do
          # ...and make the Array respond to `each_relationship`
          def relationships.each_relationship(args, &blck)
            each(&blck)
          end
          relationships
        end
      end

      object
    end

    def build_relationships(json)
      if json['object']['relationships']
        json['object']['relationships'].map do |r|
          ObjectFactory.create(r, @folder.repository)
        end
      end
    end
  end
end
