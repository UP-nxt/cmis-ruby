require 'model/server'

repository = Model::Server.repository('blueprint')

type = Model::Type.new
type.id = 'apple'
type.local_name = 'apple'
type.query_name = 'apple'
type.display_name = 'apple'
type.parent_id = 'cmis:folder'
type.base_id = 'cmis:folder'
type.description = 'appel'
type.creatable = true
type.fileable = true
type.queryable = true
type.controllable_policy = true
type.controllable_acl = true
type.fulltext_indexed = true
type.included_in_supertype_query = true

type.add_property_definition(
    id: 'color',
    localName: 'color',
    queryName: 'color',
    displayName: 'color',
    description: 'color',
    propertyType: 'string',
    cardinality: 'single',
    updatability: 'readwrite',
    inherited: false,
    required: false,
    queryable: true,
    orderable: true
)

full_type = repository.create_type(type)
puts full_type.to_hash