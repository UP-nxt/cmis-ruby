require_relative '../helper'

describe YACCL::Server do

  before :all do
    @server = YACCL::Server.new
  end

  it 'repositories' do
    @server.repositories.each do |repo|
      repo.should be_a_kind_of YACCL::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo = @server.repository(id)
    repo.should be_a_kind_of YACCL::Repository
    repo.id.should eq id
  end

end
