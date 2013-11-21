module YACCL
  module Model
    class Relationship < Object

      property_attr_accessor :name, :'cmis:name'
      property_attr_accessor :source_id, :'cmis:sourceId'
      property_attr_accessor :target_id, :'cmis:targetId'
      property_attr_accessor :repository_id, :'cmis:repositoryId'

      def self.create(raw = {})
        r = Relationship.new
        r.merge(raw)
        r
      end

      def initialize()
        super
        @properties[:'cmis:baseTypeId'] = 'cmis:relationship'
        @properties[:'cmis:objectTypeId'] = 'cmis:relationship'
      end

    end
  end
end