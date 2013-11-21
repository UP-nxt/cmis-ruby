require 'test/unit'
require_relative '../helper'

describe YACCL::RelationshipService do
  before :all do
    @test_repo_id = 'test_repo_relationship_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service
    @folder_service = @client.folder_service()

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id
    repo[:supportsRelationships] = true
    repo[:supportsPolicies] = true
    repo[:supportsItems] = true
    repo[:realtime] = true

    @repository_service.create_repository(repo)
  end

  after :all do
    @repository_service.delete_repository(@test_repo_id)
  end

  it 'should create relationship' do
    r = create_relationship('something')
    r.should_not be_nil
  end

  it 'should update relationship' do
    # prepare
    new_name ='something else'
    relationship_service = @client.relationship_service()

    r = create_relationship('something')

    # exercise
    r.name = new_name
    new_r = relationship_service.update_relationship(@test_repo_id, r)

    # verify
    new_r.name.should eql(new_name)
  end

  it 'should get relationship by id' do
    # prepare
    relationship_service = @client.relationship_service()
    r = create_relationship('something')

    # exercise
    retrieved_relationship = relationship_service.get_relationship(@test_repo_id, r.id)

    # verify
    retrieved_relationship.should_not be_nil
    retrieved_relationship.class.should eql(YACCL::Model::Relationship)
    retrieved_relationship.id.should eql(r.id)

  end

  it 'should get relationships of an object' do
    #prepare
    relationship_service = @client.relationship_service()
    r = create_relationship('something')

    # exercise 
    relationships = relationship_service.get_object_relationships(@test_repo_id, r.source_id)

    #verify
    relationships.class.should eql(Array)
    relationships.size.should eql(1)
    relationships[0].class.should eql(YACCL::Model::Relationship)
    relationships[0].id.should eql(r.id)
  end

  it 'should delete relationship' do

  end

  private
    def create_relationship(name)
      relationship_service = @client.relationship_service()

      r = YACCL::Model::Relationship.new
      r.name=name
      r.source_id=create_folder('one').id
      r.target_id=create_folder('two').id
      r = relationship_service.create_relationship(@test_repo_id, r)
      r
    end
    def create_folder(name)
      test_repo = @repository_service.get_repository(@test_repo_id)

      folder = YACCL::Model::Folder.new()
      folder.parent_id = test_repo.root_folder_id
      folder.name=name
      @folder_service.create(test_repo.id, folder)
    end

end