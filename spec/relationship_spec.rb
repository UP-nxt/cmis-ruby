require_relative './helper'

describe YACCL::Relationship do

  before :all do
    @dummy = YACCL::Server.new.repository('meta')
  end

  it 'should make properties accessible through method' do
    new_object = YACCL::Relationship.new({ succinctProperties: { myProp: 'myValue' } }, @dummy)
    new_object.properties['myProp'].should eq 'myValue'
  end

  it 'should raise methodmissing for unknown property' do
    new_object = YACCL::Relationship.new({ succinctProperties: { 'myProp' => 'myValue' } }, @dummy)
    expect { new_object.myOtherProp }.to raise_error(NoMethodError, /undefined method `myOtherProp'/)
  end

end
