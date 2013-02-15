require 'upnxt_storage_lib_cmis_ruby/model'

describe UpnxtStorageLibCmisRuby::Model::Server do
  it 'repositories' do
    UpnxtStorageLibCmisRuby::Model::Server.repositories.each do |repo|
      repo.should be_a_kind_of UpnxtStorageLibCmisRuby::Model::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo =UpnxtStorageLibCmisRuby:: Model::Server.repository(id)
    repo.should be_a_kind_of UpnxtStorageLibCmisRuby::Model::Repository
    repo.id.should eq id
  end
end
