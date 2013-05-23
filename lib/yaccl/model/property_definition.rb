module YACCL
  module Model
    class PropertyDefinition

      attr_accessor :id, :local_name, :query_name,
        :description, :inherited, :open_choice,
        :orderable, :property_type, :updatability,
        :display_name, :required, :cardinality, :queryable

      def initialize(hash={})
        @id = hash.delete(:id)
        @local_name = hash.delete(:localName)
        @query_name = hash.delete(:queryName)
        @description = hash.delete(:description)
        @inherited = hash.delete(:inherited)
        @open_choice = hash.delete(:openChoice)
        @orderable = hash.delete(:orderable)
        @property_type = hash.delete(:propertyType)
        @updatability = hash.delete(:updatability)
        @display_name = hash.delete(:displayName)
        @required = hash.delete(:required)
        @cardinality = hash.delete(:cardinality)
        @queryable = hash.delete(:queryable)
        @other = hash
      end

      def readonly?
        updatability == 'readonly'
      end

      def oncreate?
        updatability == 'oncreate'
      end

      def readwrite?
        updatability == 'readwrite'
      end

      def method_missing(m, *args, &block)
        if @other.has_key?(m)
          @other[m]
        else
          super
        end
      end

      def to_hash
        # TODO (Needed for updating type?)
      end
    end
  end
end
