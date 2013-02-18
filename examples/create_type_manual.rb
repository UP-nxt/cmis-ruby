require 'yaccl'

repository = YACCL::Model::Server.repository('blueprint')

type = YACCL::Model::Type.new
type.id = 'apple'
type.local_name = 'apple'
type.query_name = 'apple'
type.display_name = 'Apple'
type.parent_id = 'cmis:document'
type.base_id = 'cmis:document'
type.description = 'The apple fruit.'
type.creatable = true
type.fileable = true
type.queryable = true
type.controllable_policy = true
type.controllable_acl = true
type.fulltext_indexed = true
type.included_in_supertype_query = true
type.content_stream_allowed = 'allowed'
type.versionable = false

type.add_property_definition(
  id: 'color',
  localName: 'color',
  queryName: 'color',
  displayName: 'Color',
  description: 'The color.',
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
repository.delete_type(type.id)
