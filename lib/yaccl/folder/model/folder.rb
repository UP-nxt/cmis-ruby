module YACCL
  module Model

    class Folder < Object

      property_attr_accessor :id, :'cmis:objectId'
      property_attr_accessor :parent_id, :'cmis:parentId'
      property_attr_accessor :object_type_id, :'cmis:objectTypeId'
      property_attr_accessor :name, :'cmis:name'
      property_attr_accessor :path, :'cmis:path'
      property_attr_accessor :repository_id, :'cmis:repositoryId'

      def self.create(raw = {})
        f = Folder.new
        f.merge(raw)
        f
      end

      def initialize()
        super
        @properties[:'cmis:baseTypeId']='cmis:folder'
        @properties[:'cmis:objectTypeId']='cmis:folder'
      end
    end
    
  end
end