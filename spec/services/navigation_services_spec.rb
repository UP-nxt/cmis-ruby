require_relative '../helper'

describe YACCL::NavigationServices do

  before :all do
    @repo = create_repository('testrepo')
  end

  after :all do
    delete_repository('testrepo')
  end

  it 'get children' do
    root = @repo.root
    f1 = create_folder(root)

    root_children = YACCL::Services.get_children('testrepo', root.object_id, nil, nil, nil, nil, nil, nil, nil, nil)
    root_children[:objects].length.should be 1
    root_children[:objects].first[:object][:properties][:'cmis:objectId'][:value].should eq f1.object_id
  end

  it 'folder in folder - get parents' do
    root = @repo.root

    f1 = create_folder(root)
    f1_parents = YACCL::Services.get_object_parents('testrepo', f1.object_id, nil, nil, nil, nil, nil)
    f1_parents.length.should eq 1
    f1_parents.first[:object][:properties][:'cmis:objectId'][:value].should eq root.object_id

    f2 = create_folder(f1)
    f2_parents = YACCL::Services.get_object_parents('testrepo', f2.object_id, nil, nil, nil, nil, nil)
    f2_parents.length.should eq 1
    f2_parents.first[:object][:properties][:'cmis:objectId'][:value].should eq f1.object_id
  end

  it 'document in folder - get parents' do
    root = @repo.root

    f1 = create_folder(root)
    f1_parents = YACCL::Services.get_object_parents('testrepo', f1.object_id, nil, nil, nil, nil, nil)
    f1_parents.length.should eq 1
    f1_parents.first[:object][:properties][:'cmis:objectId'][:value].should eq root.object_id

    doc = create_document(f1)
    doc_parents = YACCL::Services.get_object_parents('testrepo', doc.object_id, nil, nil, nil, nil, nil)
    doc_parents.length.should eq 1
    doc_parents.first[:object][:properties][:'cmis:objectId'][:value].should eq f1.object_id
  end

  def create_folder(folder)
    new_object = @repo.new_folder
    new_object.name = 'folder'
    new_object.object_type_id = 'cmis:folder'
    folder.create(new_object)
  end

  def create_document(folder)
    new_object = @repo.new_document
    new_object.name = 'document'
    new_object.object_type_id = 'cmis:document'
    folder.create(new_object)
  end

end
