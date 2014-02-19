require_relative '../helper'

describe YACCL::Repository do

  context 'generic' do

    before do
      @id = 'meta'
      @repo = YACCL::Server.new.repository(@id)
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
      @repo.new_folder.should be_a_kind_of YACCL::Folder
      @repo.new_document.should be_a_kind_of YACCL::Document
      @repo.new_relationship.should be_a_kind_of YACCL::Relationship
      @repo.new_policy.should be_a_kind_of YACCL::Policy
      @repo.new_item.should be_a_kind_of YACCL::Item
    end

    it 'repositories' do
      YACCL::Server.new.repositories
    end

    it 'repository' do
      r = YACCL::Server.new.repository('generali')
      r.name.should eq 'generali'
    end

    it 'root' do
      root = @repo.root
      root.should be_a_kind_of YACCL::Folder
      root.cmis_object_id.should eq @repo.root_folder_id
    end

    it 'object' do
      id = @repo.root_folder_id
      object = @repo.object(id)
      object.should be_a_kind_of YACCL::Folder
      object.cmis_object_id.should eq id
    end

    it 'type - document' do
      document = @repo.type('cmis:document')
      document.should be_a_kind_of YACCL::Type
      document.id.should eq 'cmis:document'
    end

    it 'type - folder' do
      folder = @repo.type('cmis:folder')
      folder.should be_a_kind_of YACCL::Type
      folder.id.should eq 'cmis:folder'
    end
  end

  context 'upn' do

    before :all do
      @repo = create_repository('testrepository')
    end

    after :all do
      delete_repository('testrepository')
    end

    it 'type - relationship' do
      relationship = @repo.type('cmis:relationship')
      relationship.should be_a_kind_of YACCL::Type
      relationship.id.should eq 'cmis:relationship'
    end

    it 'type - policy' do
      policy = @repo.type('cmis:policy')
      policy.should be_a_kind_of YACCL::Type
      policy.id.should eq 'cmis:policy'
    end

    it 'type - item' do
      begin
        item = @repo.type('cmis:item')
        item.should be_a_kind_of YACCL::Type
        item.id.should eq 'cmis:item'
      end unless @repo.cmis_version_supported < '1.1'
    end

    it 'create, get, delete type - document' do
      type_id = 'apple'

      type = YACCL::Type.new
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

      type.add_property_definition(id: 'color',
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
                                   orderable: true)

      @repo.create_type(type)

      @repo.type(type_id).tap do |t|
        t.should be_a_kind_of YACCL::Type
        t.id.should eq type_id
      end

      @repo.type(type_id).delete
    end

  end
end
