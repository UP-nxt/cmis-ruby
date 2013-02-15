require 'upnxt_storage_lib_cmis_ruby/model'

describe UpnxtStorageLibCmisRuby::Model::Service do
  it 'repositories' do
    UpnxtStorageLibCmisRuby::Model::Service.repositories.each do |repo|
      repo.should be_a_kind_of UpnxtStorageLibCmisRuby::Model::Repository
    end
  end

  it 'repository' do
    id = 'meta'
    repo =UpnxtStorageLibCmisRuby:: Model::Service.repository(id)
    repo.should be_a_kind_of UpnxtStorageLibCmisRuby::Model::Repository
    repo.id.should eq id
  end
end
