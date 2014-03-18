require 'spec_helper'

module CMIS
  describe Folder do
    before do
      @folder = create_folder
    end

    after do
      @folder.delete
    end

    describe '#parent' do
      it 'is nil for the root folder' do
        expect(repository.root.parent).to be_nil
      end

      it 'is the root folder for its child' do
        expect(@folder.parent.cmis_object_id).to eq(repository.root_folder_id)
      end
    end

    def create_folder
      folder = repository.new_folder
      folder.name = 'test_folder'
      folder.object_type_id = 'cmis:folder'
      repository.root.create(folder)
    end
  end
end

#   it 'create relationship' do
#     new_object = @repo.new_relationship
#     new_object.name = 'rel1'
#     new_object.object_type_id = 'cmis:relationship'
#     lambda { @repo.root.create(new_object) }.should raise_exception
#   end

#   it 'create item' do
#     begin
#       new_object = @repo.new_item
#       new_object.name = 'item1'
#       new_object.object_type_id = 'cmis:item'
#       object = @repo.root.create(new_object)
#       object.should be_a_kind_of CMIS::Item
#       object.name.should eq 'item1'
#       object.delete
#     end unless @repo.cmis_version_supported < '1.1'
#   end

#   it 'create object' do
#     new_object = CMIS::Object.new({}, @repo)
#     new_object.name = 'object1'
#     new_object.object_type_id = 'cmis:folder'
#     lambda { @repo.root.create(new_object) }.should raise_exception
#   end
# end
