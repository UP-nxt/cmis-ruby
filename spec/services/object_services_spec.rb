require_relative '../helper'

describe YACCL::NavigationServices do

  before :all do
    @repo = create_repository('testrepo')
  end

  after :all do
    delete_repository('testrepo')
  end

  # Document does not get filed in the folder
  it 'create_document' do
    root = @repo.root

    properties = {'cmis:objectTypeId' => 'cmis:document', 'cmis:name' => 'document'}
    YACCL::Services.create_document('testrepo', properties, root.object_id, nil, nil, nil,nil, nil)

    root_children = YACCL::Services.get_children('testrepo', root.object_id, nil, nil, nil, nil, nil, nil, nil, nil)
    root_children[:objects].length.should be 1
    root_children[:objects].first[:object][:properties][:'cmis:objectId'][:value].should eq f1.object_id
  end

end
