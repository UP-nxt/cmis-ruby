require 'test/unit'
require_relative '../helper'

describe YACCL::RepositoryService do
  before :all do
    @test_repo_id = 'test_repo_repository_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id

    @repository_service.create_repository(repo)
  end

  after :all do
    @repository_service.delete_repository(@test_repo_id)
  end
  
  it 'should get repository info' do
    repo = @repository_service.get_repository(@test_repo_id)

    repo.should_not be_nil
    repo.id.should eql(@test_repo_id)
  end

  it 'should get all repositories' do
    repos = @repository_service.get_repositories()
    
    repos.should_not be_nil
    repos.each do |repo|
      repo.class.should eql(YACCL::Model::Repository)
    end

  end

end