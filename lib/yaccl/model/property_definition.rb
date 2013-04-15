module YACCL
  module Model
    class PropertyDefinition

      attr_accessor :id, :local_name, :query_name, :inherited,
        :open_choise, :orderable, :property_type, :updatability,
        :display_name, :required, :cardinality, :queryable

      def initialize(hash={})
        @id = hash[:id]
        @local_name = hash[:localName]
        @query_name = hash[:queryName]
        @inherited = hash[:inherited]
        @open_choice = hash[:openChoice]
        @orderable = hash[:orderable]
        @property_type = hash[:propertyType]
        @updatability = hash[:updatability]
        @display_name = hash[:displayName]
        @required = hash[:required]
        @cardinality = hash[:cardinality]
        @queryable = hash[:queryable]
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

      def to_hash
        # TODO (Needed for updating type?)
      end
    end
  end
end
