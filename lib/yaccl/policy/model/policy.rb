module YACCL
  module Model
    class Policy < Object
      
      property_attr_accessor :name, :'cmis:name'
      property_attr_accessor :text, :'cmis:policyText'
      property_attr_accessor :repository_id, :'cmis:repositoryId'

      def self.create(raw = {})
        p = Policy.new()
        p.merge(raw)
        p
      end

      def initialize()
        super
        @properties[:'cmis:baseTypeId'] = 'cmis:policy'
        @properties[:'cmis:objectTypeId'] = 'cmis:policy'
      end


    end
  end
end