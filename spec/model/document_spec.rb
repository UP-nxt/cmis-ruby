require 'upnxt_storage_lib_cmis_ruby/model'
require_relative 'repository_home'

describe Model::Document do

  before do
    @repo = create_repository('test_document')
  end

  after do
    delete_repository('test_document')
  end

  it 'create_in_folder with content' do
    new_object = @repo.new_document
    new_object.name = 'doc1'
    new_object.object_type_id = 'cmis:document'
    new_object.set_content(StringIO.new('content1'), 'text/plain', 'doc1.txt') # set content on detached doc
    doc = new_object.create_in_folder(@repo.root_folder_id)
    doc.name.should eq 'doc1'
    doc.content_stream_mime_type.should eq 'text/plain'
    doc.content_stream_file_name.should eq 'doc1.txt'
    doc.content.should eq 'content1'
    doc.delete
  end
end