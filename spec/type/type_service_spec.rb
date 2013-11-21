require 'test/unit'
require_relative '../helper'

describe YACCL::TypeService do
  before :all do
    @test_repo_id = 'test_repo_type_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service
    @folder_service = @client.folder_service()

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id

    @repository_service.create_repository(repo)
  end

  after :all do
    @repository_service.delete_repository(@test_repo_id)
  end

  it 'should get definition' do
    type_service = @client.type_service()
    type = type_service.get_type_definition(@test_repo_id, 'cmis:folder')
    type.class.should eql(YACCL::Model::Type)
  end 

  it 'should create type' do
    type_service = @client.type_service()
    
    t = YACCL::Model::Type.new
    t.id='sometype'
    t.local_name='sometype_name'
    t.query_name='sometype'
    t.display_name = 'some type'
    t.base_id='cmis:document'
    t.parent_id='cmis:document'

    pd = YACCL::Model::Type::PropertyDefinition.new
    pd.id='someproperty'
    pd.name='some property-definition'
    pd.local_name='someproperty'
    pd.query_name='someproperty'
    t.property_definitions << pd

    type = type_service.create_type(@test_repo_id, t)
  end

  it 'should update basic elements of type' do
    # prepare
    type_service = @client.type_service()
    t = create_type('sometype', 'cmis:folder')
    t.display_name = 'something'

    # exercise
    type_service.update_type(@test_repo_id, t)

    # verify
    new_t = type_service.get_type_definition(@test_repo_id, t.id)
    new_t.display_name.should eql(t.display_name)
  end

  it 'should update property definitions of type' do
    # prepare
    property_definition_id = 'some_prop'
    type_service = @client.type_service()
    t = create_type('sometype', 'cmis:folder')
    t.property_definitions<<create_property_definition(property_definition_id)

    # exercise
    type_service.update_type(@test_repo_id, t)

    # verify
    t_new = type_service.get_type_definition(@test_repo_id, t.id)
    pd = t_new.property_definitions.select { |pd| pd.id==property_definition_id }.first

    pd.should_not be_nil
    pd.id.should eql(property_definition_id)

  end

  it 'should delete type' do
    # prepare
    type_service = @client.type_service()
    t = create_type('sometype', 'cmis:folder')

    # exercise
    type_service.delete_type(@test_repo_id, t.id)

    # verify
    lambda { type_service.get_type_definition(@test_repo_id, t.id) }.should raise_error(YACCL::CMISRequestError) { |error| error.code.should eql(404) }
  end

  it 'should get children' do
    # prepare
    type_service = @client.type_service()
    t = create_type('subfolder', 'cmis:folder')

    # exercise
    types = type_service.get_type_children(@test_repo_id, 'cmis:folder')

    #verify
    types.size.should eql(1)
    types.each do |t|
      t.class.should eql(YACCL::Model::Type)
    end

  end

  it 'should get descendants' do
    # prepare
    type_service = @client.type_service()
    create_type('subfolder', 'cmis:folder')
    create_type('undersubfolder', 'cmis:folder', 'subfolder')
    create_type('undersubfolder2', 'cmis:folder', 'subfolder')
    create_type('child_of_undersubfolder', 'cmis:folder', 'undersubfolder')
    create_type('subfolder2', 'cmis:folder')

    # exercise
    types = type_service.get_type_descendants(@test_repo_id, 'cmis:folder')

    #verify
    types.size.should eql(2)
    t1 = types[0]
    t1.class.should eql(YACCL::Model::Type)
    t1.id.should eql('subfolder')
    t1.children.size==2
    t1.children[0].class.should eql(YACCL::Model::Type)
    t1.children[0][:parent_id] = 'subfolder'
    t1.children[1].class.should eql(YACCL::Model::Type)
    t1.children[1][:parent_id] = 'subfolder'

    t2 = types[1]
    t2.children.size.should eql(0)
  end

  it 'should create type with descendants' do
    # prepare
    under_subfolder_type_name = 'under_subfolder'
    type_service = @client.type_service()
    subfolder_type = build_type('subfolder', 'cmis:folder')
    subfolder_type.children<<build_type(under_subfolder_type_name, 'cmis:folder')

    # exercise
    saved_type = type_service.create_type(@test_repo_id, subfolder_type)

    #verify
    saved_type.class.should eql(YACCL::Model::Type)
    saved_type.children.size.should eql(1)
    saved_type.children[0].id.should eql(under_subfolder_type_name)
  end

  private
    def create_type(name, base_type, parent_type = base_type)
      t = build_type(name, base_type, parent_type)
      @client.type_service().create_type(@test_repo_id, t)
    end

    def build_type(name, base_type, parent_type = base_type)
      t = YACCL::Model::Type.new
      t.id=name
      t.local_name=name
      t.query_name=name
      t.display_name = name
      t.base_id=base_type
      t.parent_id=parent_type

      t
    end

    def create_property_definition(id)
      pd = YACCL::Model::Type::PropertyDefinition.new
      pd.id=id
      pd.name="name of #{id}"
      pd.local_name=id
      pd.query_name=id
      pd
    end
end