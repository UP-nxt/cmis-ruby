require_relative './helper'

describe CMIS::Server do

  before :all do
    @server = CMIS::Server.new
  end

  it 'repositories' do
    @server.repositories.each do |repo|
      repo.should be_a_kind_of CMIS::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo = @server.repository(id)
    repo.should be_a_kind_of CMIS::Repository
    repo.id.should eq id
  end

end
