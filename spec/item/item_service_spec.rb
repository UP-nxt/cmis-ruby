require 'test/unit'
require_relative '../helper'

describe YACCL::FolderService do
  before :all do
    @test_repo_id = 'test_repo_item_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service
    @folder_service = @client.folder_service()

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id
    repo[:supportsItems] = true

    @repository_service.create_repository(repo)
  end

  after :all do
    @repository_service.delete_repository(@test_repo_id)
  end

  it 'should create item' do
    item_service = @client.item_service()
    repo = @repository_service.get_repository(@test_repo_id)

    item = YACCL::Model::Item.new()
    item.name='something'

    item_service.create_item(@test_repo_id, item)
  end

  it 'should update item' do
    # prepare
    new_name = 'something'
    item_service = @client.item_service()
    item = create_item('some item')

    # exercise
    item.name=new_name
    updated_item = item_service.update_item(@test_repo_id, item)

    # verify 
    updated_item.name.should eql(new_name)
  end

  it 'should get item' do
    # prepare
    item_service = @client.item_service()
    item = create_item('some1')

    # exercise
    retrieved_item = item_service.get_item(@test_repo_id, item.id)

    # verify
    retrieved_item.should_not be_nil
    retrieved_item.id.should eql(item.id)
  end

  it 'should delete item' do
    # prepare
    item_service = @client.item_service()
    item = create_item('some1')

    # exercise
    item_service.delete_item(@test_repo_id, item.id)

    # verify
    lambda { item_service.get_item(@test_repo_id, item.id) }.should raise_error(YACCL::CMISRequestError) { |error| error.code.should eql(404) }
  end


  private
    def create_item(name)
      item_service = @client.item_service()
      repo = @repository_service.get_repository(@test_repo_id)

      item = YACCL::Model::Item.new()
      item.name=name

      item_service.create_item(@test_repo_id, item)
    end

end