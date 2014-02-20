require_relative './helper'

describe YACCL::Folder do

  before :all do
    @repo = create_repository('test')
  end

  after :all do
    delete_repository('test')
  end

  it 'parent - root' do
    @repo.root.parent.should be_nil
  end

  it 'parent - root child' do
    new_object = @repo.new_folder
    new_object.name = 'folder1'
    new_object.object_type_id = 'cmis:folder'
    folder = @repo.root.create(new_object)
    folder.parent.cmis_object_id.should eq @repo.root_folder_id
    folder.delete
  end

  it 'create document' do
    new_object = @repo.new_document
    new_object.name = 'doc1'
    new_object.object_type_id = 'cmis:document'
    new_object.set_content(StringIO.new('apple is a fruit'), 'text/plain', 'apple.txt')
    object = @repo.root.create(new_object)
    object.should be_a_kind_of YACCL::Document
    object.name.should eq 'doc1'
    object.content_stream_mime_type.should eq 'text/plain'
    object.content_stream_file_name.should eq 'apple.txt'
    object.content.should eq 'apple is a fruit'
    object.delete
  end

  it 'create folder' do
    new_object = @repo.new_folder
    new_object.name = 'folder1'
    new_object.object_type_id = 'cmis:folder'
    object = @repo.root.create(new_object)
    object.should be_a_kind_of YACCL::Folder
    object.name.should eq 'folder1'
    object.delete
  end

  it 'create relationship' do
    new_object = @repo.new_relationship
    new_object.name = 'rel1'
    new_object.object_type_id = 'cmis:relationship'
    lambda { @repo.root.create(new_object) }.should raise_exception
  end

  it 'create item' do
    begin
      new_object = @repo.new_item
      new_object.name = 'item1'
      new_object.object_type_id = 'cmis:item'
      object = @repo.root.create(new_object)
      object.should be_a_kind_of YACCL::Item
      object.name.should eq 'item1'
      object.delete
    end unless @repo.cmis_version_supported < '1.1'
  end

  it 'create object' do
    new_object = YACCL::Object.new({}, @repo)
    new_object.name = 'object1'
    new_object.object_type_id = 'cmis:folder'
    lambda { @repo.root.create(new_object) }.should raise_exception
  end
end
