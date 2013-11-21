require 'test/unit'
require_relative '../helper'

describe YACCL::DocumentService do
  before :all do
    @test_repo_id = 'test_repo_document_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service
    @folder_service = @client.folder_service()

    clear_all()

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id

    @repository_service.create_repository(repo)

    @repository = @repository_service.get_repository(@test_repo_id)
  end

  after :all do
    clear_all()
  end

  it 'should create document' do
    document_service = @client.document_service()

    d = YACCL::Model::Document.new()
    d.name="test"

    document_service.create_document(@test_repo_id, d)
  end

  it 'should update document' do
    # prepare
    new_name = 'something'
    document_service = @client.document_service()
    d = YACCL::Model::Document.new()
    d.name="test"
    d = document_service.create_document(@test_repo_id, d)

    # exercise
    d.name=new_name
    new_d = document_service.update_document(@test_repo_id, d)

    #verify
    new_d.name.should eql(new_name)
  end

  it 'should get document' do
    ds = @client.document_service()

    test_document = create_document('something')

    d = ds.get_document(@test_repo_id, test_document.id)

    d.should_not be_nil
    d.id.should eql(test_document.id)
  end

  it 'should remove document' do
    # prepare
    ds = @client.document_service()

    # exercise
    test_document = create_document('something')
    ds.delete_document(@test_repo_id, test_document.id)

    # verify
    lambda { ds.get_document(@test_repo_id, test_document.id) }.should raise_error(YACCL::CMISRequestError) { |error| error.code.should eql(404) }
  end

  it 'should set content to document' do
    # prepare
    ds = @client.document_service()
    d = create_document('something')

    # exercise
    d.set_content(YACCL::Model::Content.create(stream: StringIO.new('content'), mime_type: 'text/plain', filename: 'plain.txt'))

    # verify
    new_d = ds.get_document(@test_repo_id, d.id)
    new_d.content.should eql('content')

  end

  it 'should create document with local content' do
    # prepare
    ds = @client.document_service()
    d = YACCL::Model::Document.new()
    d.name="test"
    d.set_content(YACCL::Model::Content.create(stream: StringIO.new('content'), mime_type: 'text/plain', filename: 'plain.txt'))
    d = ds.create_document(@test_repo_id, d)

    # exercise
    new_d = ds.get_document(@test_repo_id, d.id)

    # verify
    new_d.content.should eql('content')
  end

  it 'should delete content of document' do
    #prepare
    content = YACCL::Model::Content.create(stream: StringIO.new('content'), mime_type: 'text/plain', filename: 'plain.txt')
    ds = @client.document_service()
    d = create_document('something')
    d = d.set_content(content)

    # exercise
    ds.delete_content_stream(@test_repo_id, d.id, d.change_token.to_i)

    # verify
    new_d = ds.get_document(@test_repo_id, d.id)
    new_d.content.should be_nil
  end

  # it 'should append content to document' do
  #   #prepare
  #   content = YACCL::Model::Content.create(stream: StringIO.new('content'), mime_type: 'text/plain', filename: 'plain.txt')
  #   ds = @client.document_service()
  #   d = create_document('something')
  #   d = d.set_content(content)

  #   # exercise
  #   ds.append_content_stream(@test_repo_id, d.id, content, d.change_token.to_i, true)

  #   # verify
  #   new_d = ds.get_document(@test_repo_id, d.id)
  #   new_d.content.should eql('contentcontent')
  # end

  private
    def create_document(name)
      d = YACCL::Model::Document.new()
      d.name="test"

      @client.document_service().create_document(@test_repo_id, d)
    end

    def clear_all()
      begin
        @repository_service.delete_repository(@test_repo_id)
      rescue YACCL::CMISRequestError=>e
        #do nothing. maybe the repo don't exist
      end
    end
  
end