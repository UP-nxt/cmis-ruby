require 'test/unit'
require_relative '../helper'

describe YACCL::PolicyService do
  before :all do
    @test_repo_id = 'test_repo_policy_service'
    @client = YACCL::CmisClient.new($SERVER, $USER, $PASSWORD)
    @repository_service = @client.repository_service
    @folder_service = @client.folder_service()

    repo = YACCL::Model::Repository.new()
    repo.id=@test_repo_id
    repo.name=@test_repo_id
    repo[:supportsRelationships] = true
    repo[:supportsPolicies] = true
    repo[:supportsItems] = true
    repo[:realtime] = true

    @repository_service.create_repository(repo)
  end

  after :all do
    @repository_service.delete_repository(@test_repo_id)
  end  

  it 'should create policy' do
    p = create_policy('something')
    p.class.should eql(YACCL::Model::Policy)
  end

  it 'should update policy' do
    # prepare
    new_name = 'something else'
    policy_service = @client.policy_service()
    p = create_policy('something')

    # exercise
    p.name=new_name
    updated_policy = policy_service.update_policy(@test_repo_id, p)

    # verify
    updated_policy.should_not be_nil
    updated_policy.name.should eql(new_name)
  end

  it 'should apply policy' do
    # prepare
    policy_service = @client.policy_service()
    
    policy = create_policy('something')
    policy2 = create_policy('something else')
    type = create_type('some_policy_applicable_type', 'cmis:document')
    document = create_document('some_policy_applicable_type', 'somename')
    

    # exercise
    document = policy_service.apply_policy(@test_repo_id, policy.id, document.id)
    document = policy_service.apply_policy(@test_repo_id, policy2.id, document.id)

    # verify
    retrieved_document = @client.document_service().get_document(@test_repo_id, document.id)
    
    retrieved_document.policy_ids.include?(policy.id).should be_true
    retrieved_document.policy_ids.include?(policy2.id).should be_true
  end

  it 'should remove policy from object' do
    # prepare
    policy_service = @client.policy_service()
    document_service =  @client.document_service()

    policy = create_policy('something')
    type = create_type('some_policy_applicable_type', 'cmis:document')
    document = create_document('some_policy_applicable_type', 'somename')
    document = policy_service.apply_policy(@test_repo_id, policy.id, document.id)
    document = document_service.get_document(@test_repo_id, document.id)

    # exercise
    policy_service.remove_policy(@test_repo_id, policy.id, document.id)

    # verify
    document = document_service.get_document(@test_repo_id, document.id)
    document.policy_ids.include?(policy.id).should be_false
  end

  it 'should delete policy' do
    # prepare
    policy_service = @client.policy_service()
    policy = create_policy('something')

    # exercise
    policy_service.delete_policy(@test_repo_id, policy.id)

    # verify
    lambda { policy_service.get_policy(@test_repo_id, policy.id) }.should raise_error(YACCL::CMISRequestError) { |error| error.code.should eql(404) }
  end

  private
    def create_policy(name)
      policy_service = @client.policy_service()

      p = YACCL::Model::Policy.new
      p.name=name
      p.text=name+'text'

      policy_service.create_policy(@test_repo_id, p)
    end

    def create_document(type, name)
      ds = @client.document_service()
      
      d = YACCL::Model::Document.new()
      d.object_type_id=type
      d.name=name

      ds.create_document(@test_repo_id, d)
    end

    def create_type(name, base_type, parent_type = base_type)
      t = build_type(name, base_type, parent_type)
      @client.type_service().create_type(@test_repo_id, t)
    end

    def build_type(name, base_type, parent_type = base_type)
      t = YACCL::Model::Type.new
      t.id=name
      t.local_name=name
      t.query_name=name
      t.display_name = name
      t.base_id=base_type
      t.parent_id=parent_type

      t
    end

end