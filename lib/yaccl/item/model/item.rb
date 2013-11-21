module YACCL
  module Model
    class Item < Object
      
      attr_accessor :parent_id
      property_attr_accessor :id, :'cmis:objectId'
      property_attr_accessor :repository_id, :'cmis:repositoryId'
      property_attr_accessor :name, :'cmis:name'

      def self.create(raw = {})
        item = Item.new
        item.merge(raw)
        item
      end

      def initialize()
        super
        @properties[:'cmis:baseTypeId'] = 'cmis:item'
        @properties[:'cmis:objectTypeId'] = 'cmis:item'
      end

    end
  end
end