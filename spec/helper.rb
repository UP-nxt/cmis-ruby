require 'yaccl'
require 'json'

YACCL.init('http://localhost:8080/upncmis/browser')

def create_repository(id)
  meta = YACCL::Model::Server.repository('meta')

  repo_type = meta.type('repository')
  property_definitions = repo_type.property_definitions.keys

  f = meta.new_folder
  f.name = id
  f.object_type_id = repo_type.id
  f.properties[:supportsRelationships] = true if property_definitions.include?(:supportsRelationships)
  f.properties[:supportsPolicies] = true if property_definitions.include?(:supportsPolicies)
  f.properties[:supportsItem] = true if property_definitions.include?(:supportsItems)
  meta.root.create(f)

  YACCL::Model::Server.repository(id)
end

def delete_repository(id)
  YACCL::Model::Server.repository('meta').object(id).delete
end
