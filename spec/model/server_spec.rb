require_relative '../helper'

describe YACCL::Model::Service do
  it 'repositories' do
    YACCL::Model::Service.repositories.each do |repo|
      repo.should be_a_kind_of YACCL::Model::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo = YACCL::Model::Service.repository(id)
    repo.should be_a_kind_of YACCL::Model::Repository
    repo.id.should eq id
  end
end
