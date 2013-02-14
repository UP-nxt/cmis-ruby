require 'upnxt_storage_lib_cmis_ruby/model'

describe Model::Server do
  it 'repositories' do
    Model::Server.repositories.each do |repo|
      repo.should be_a_kind_of Model::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo = Model::Server.repository(id)
    repo.should be_a_kind_of Model::Repository
    repo.id.should.eql? id
  end
end
