require_relative '../helper'

describe YACCL::NavigationServices do

  before :all do
    @repo = create_repository('testrepo')
  end

  after :all do
    delete_repository('testrepo')
  end

  it 'create_document' do
    root = @repo.root

    properties = {'cmis:objectTypeId' => 'cmis:document', 'cmis:name' => 'document'}
    YACCL::Services.create_document('testrepo', properties, root.object_id, nil, nil, nil, nil, nil)

    root_children = YACCL::Services.get_children('testrepo', root.object_id, nil, nil, nil, nil, nil, nil, nil, nil)
    root_children[:objects].length.should be 1
  end

  it 'get content stream' do
    root = @repo.root

    properties = {'cmis:objectTypeId' => 'cmis:document', 'cmis:name' => 'document'}
    content = { stream: StringIO.new('Apples are green.'), mime_type: 'text/plain', filename: 'apples.txt' }
    doc = YACCL::Services.create_document('testrepo', properties, root.object_id, content, nil, nil, nil, nil)
    doc_id = doc[:succinctProperties][:'cmis:objectId']

    YACCL::Services.get_content_stream('testrepo', doc_id, nil, nil, nil).should eq 'Apples are green.'
  end

  it 'get content stream when not set' do
    root = @repo.root

    properties = {'cmis:objectTypeId' => 'cmis:document', 'cmis:name' => 'document'}
    doc = YACCL::Services.create_document('testrepo', properties, root.object_id, nil, nil, nil, nil, nil)
    doc_id = doc[:succinctProperties][:'cmis:objectId']

    lambda { YACCL::Services.get_content_stream('testrepo', doc_id, nil, nil, nil) }.should raise_exception
  end

end
