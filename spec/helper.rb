require 'cmis-ruby'
require 'json'

META = CMIS::Server.new.repository('meta')

def create_repository(id)
  delete_repository(id)

  repo_type = META.type('repository')
  property_definitions = repo_type.property_definitions.keys

  f = repo_type.new_object
  f.name = id
  f.properties[:id] = id
  f.properties[:supportsRelationships] = true if property_definitions.include?('supportsRelationships')
  f.properties[:supportsPolicies] = true if property_definitions.include?('supportsPolicies')
  f.properties[:supportsItems] = true if property_definitions.include?('supportsItems')
  f.properties[:realtime] = true if property_definitions.include?('realtime')
  META.root.create(f)

  CMIS::Server.new.repository(id)
end

def delete_repository(id)
  META.object(id).delete
rescue CMIS::Exceptions::ObjectNotFound => ex
end
