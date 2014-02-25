require_relative './helper'

describe CMIS::Type do

  before :all do
    @repo = create_repository('test')
  end

  after :all do
    delete_repository('test')
  end

  it 'shoud update types' do
    type = @repo.new_type
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

    full_type = type.create

    new_prop = CMIS::PropertyDefinition.new(
      id: 'taste',
      localName: 'taste',
      queryName: 'taste',
      displayName: 'Taste',
      description: 'The taste.',
      propertyType: 'string',
      cardinality: 'single',
      updatability: 'readwrite',
      inherited: false,
      required: false,
      queryable: true,
      orderable: true
    )

    full_type.update([new_prop])

    full_type.delete
  end

end
