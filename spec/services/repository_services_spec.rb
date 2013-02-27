require_relative '../helper'

describe YACCL::RepositoryServices do

  before :all do
    create_repository('testrepo')
  end

  after :all do
    delete_repository('testrepo')
  end

  it 'get repositories' do
    repos = YACCL::Services.get_repositories
    repos.keys.should include :testrepo
    repo = repos[:testrepo]
    repo[:repositoryId].should eq 'testrepo'
  end

  it 'get repository info' do
    repos = YACCL::Services.get_repository_info('testrepo')
    repos.keys.should eq [:testrepo]
    repo = repos[:testrepo]
    repo[:repositoryId].should eq 'testrepo'
  end
end
