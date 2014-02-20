require_relative './helper'

describe YACCL::Object do

  before :all do
    @repo = create_repository('test')
  end

  after :all do
    delete_repository('test')
  end

  it 'repository' do
    doc = create_document
    doc.repository.should be_a_kind_of YACCL::Repository
    doc.repository.id.should eq 'test'
    doc.delete
  end

  it 'object_type' do
    doc = create_document
    doc.object_type.should be_a_kind_of YACCL::Type
    doc.object_type.id.should eq 'cmis:document'
    doc.delete
  end

  it 'delete' do
    doc = create_document
    doc.delete
    # TODO check
  end

  it 'allowable actions' do
    doc = create_document
    actions = doc.allowable_actions
    actions.should_not be_nil
    actions.should_not be_empty
    actions.values.each { |v| [true, false].should include v }
    doc.delete
  end

  it 'relationships' do
    doc = create_document
    rels = doc.relationships
    rels.should_not be_nil
    rels.each do |r|
      r.should be_a_kind_of YACCL::Relationship
    end
    doc.delete
  end

  it 'policies' do
    doc = create_document
    pols = doc.policies
    pols.should_not be_nil
    pols.each do |p|
      p.should be_a_kind_of YACCL::Policy
    end
    doc.delete
  end

  it 'unfile' do
    doc = create_document
    doc.unfile
    #TODO check
    doc.delete
  end

  it 'acls' do
    doc = create_document
    acls = doc.acls
    acls.should_not be_nil
    acls.should_not be_empty
    acls.should have_key :aces
    acls.should have_key :isExact
    [true, false].should include acls[:isExact]
    doc.delete
  end

  # it 'add aces' do
  #   doc = create_document
  #   doc.add_aces({})
  #   #TODO check
  #   doc.delete
  # end

  # it 'remove aces' do
  #   doc = create_document
  #   doc.remove_aces({})
  #   #TODO check
  #   doc.delete
  # end

  def create_document
    new_object = @repo.new_document
    new_object.name = 'doc'
    new_object.object_type_id = 'cmis:document'
    @repo.root.create(new_object)
  end
end
