require 'upnxt_storage_lib_cmis_ruby/model'
require_relative 'repository_home'

describe Model::Repository do

  context 'generic' do
    before do
      @id = 'meta'
      @repo = Model::Server.repository(@id)
    end

    it 'id' do
      @repo.id.should.eql? @id
    end

    it 'fields' do
      @repo.id.should_not be_nil
      @repo.name.should_not be_nil
      @repo.product_version.should_not be_nil
      @repo.description.should_not be_nil
      @repo.root_folder_id.should_not be_nil
      @repo.capabilities.should_not be_nil
      @repo.url.should_not be_nil
      @repo.changes_on_type.should_not be_nil
      @repo.root_folder_url.should_not be_nil
      @repo.product_name.should_not be_nil
      @repo.product_version.should_not be_nil

      %w(1.0 1.1).should include @repo.cmis_version_supported
    end

    it 'new object' do
      @repo.new_folder.should be_a_kind_of Model::Folder
      @repo.new_document.should be_a_kind_of Model::Document
      @repo.new_relationship.should be_a_kind_of Model::Relationship
      @repo.new_policy.should be_a_kind_of Model::Policy
      @repo.new_item.should be_a_kind_of Model::Item
    end

    it 'root' do
      root = @repo.root
      root.should be_a_kind_of Model::Folder
      root.object_id.should eq @repo.root_folder_id
    end

    it 'object' do
      id = @repo.root_folder_id
      object = @repo.object(id)
      object.should be_a_kind_of Model::Folder
      object.object_id.should eq id
    end

    it 'type' do
      document = @repo.type('cmis:document')
      document.should be_a_kind_of Model::Type
      document.id.should eq 'cmis:document'

      folder = @repo.type('cmis:folder')
      folder.should be_a_kind_of Model::Type
      folder.id.should eq 'cmis:folder'
    end
  end

  context 'upn' do
    before do
      @repo = create_repository('test_repository')
    end

    after do
      delete_repository('test_repository')
    end

    it 'create, get, delete type - document' do
      type_id = 'apple'

      type = Model::Type.new
      type.id = type_id
      type.local_name = 'apple'
      type.query_name = 'apple'
      type.display_name = 'apple'
      type.parent_id = 'cmis:document'
      type.base_id = 'cmis:document'
      type.description = 'appel'
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

      @repo.create_type(type)
      @repo.type(type_id).tap do |t|
        t.should be_a_kind_of Model::Type
        t.id.should eq type_id
      end
      @repo.delete_type(type_id)
    end

  end
end
