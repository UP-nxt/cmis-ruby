require_relative '../helper'

describe YACCL::Model::Relationship do

  it 'should make properties accessible through method' do
    new_object = YACCL::Model::Relationship.new('repoId', {succinctProperties: {myProp: 'myValue'}})
    new_object.myProp.should eq 'myValue'
  end

  it 'should raise methodmissing for unknown property' do
    new_object = YACCL::Model::Relationship.new('repoId', {succinctProperties: {'myProp' => 'myValue'}})
    expect {new_object.myOtherProp}.to raise_error(NoMethodError, /undefined method `myOtherProp'/)
  end

end
