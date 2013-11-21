require 'test/unit'
require_relative '../helper'

describe YACCL::FolderService do
  before :all do
    @test_repo_id = 'test_repo_folder_service'
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

  it 'should create folder' do
    folder = create_folder('some name')
    folder.id.should satisfy do |id|
      id!=nil
    end
  end

  it 'should get all folders' do
    folders = @folder_service.get_all_folders(@test_repo_id)

    folders.size.should satisfy do |size|
      size>0
    end

    folders.each do |folder|
      folder.class.should eql(YACCL::Model::Folder)
    end

   end

   it 'should update folder' do
    # prepare
    name = 'some name'
    new_name='some new name'
    folder = create_folder(name)
    # execute
    folder.name=new_name
    
    @folder_service.update_folder(folder.repository_id, folder)

    # verify
    updated_folder = @folder_service.get_folder(folder.repository_id, folder.id)
    updated_folder.name.should eql(new_name)
   end

   private
    def create_folder(name)
      test_repo = @repository_service.get_repository(@test_repo_id)

      folder = YACCL::Model::Folder.new()
      folder.parent_id = test_repo.root_folder_id
      folder.name=name
      @folder_service.create(test_repo.id, folder)
    end

end