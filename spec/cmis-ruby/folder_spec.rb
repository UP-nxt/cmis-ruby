require 'spec_helper'

module CMIS
  describe Folder do
    describe '#parent' do
      before do
        @folder = create_folder
      end

      after do
        @folder.delete
      end

      it 'is nil for the root folder' do
        expect(repository.root.parent).to be_nil
      end

      it 'is the root folder for its child' do
        expect(@folder.parent.cmis_object_id).to eq(repository.root_folder_id)
      end

      def create_folder
        folder = repository.new_folder
        folder.name = 'test_folder'
        folder.object_type_id = 'cmis:folder'
        repository.root.create(folder)
      end
    end

    describe '#create' do
      context 'when creating a relationship in a folder' do
        it 'raises an exception' do
          relationship = repository.new_relationship
          relationship.name = 'test_relationship'
          relationship.object_type_id = 'cmis:relationship'
          expect {
            repository.root.create(new_object)
          }.to raise_exception
        end
      end

      context 'when creating an item in a folder' do
        it 'raises an exception' do
          item = repository.new_item
          item.name = 'test_item'
          item.object_type_id = 'cmis:item'
          item = repository.root.create(item)
          expect(item).to be_a CMIS::Item
          expect(item.name).to eq('test_item')
          item.delete
        end
      end

      context 'when creating a plain object in a folder' do
        it 'raises an exception' do
          new_object = CMIS::Object.new({}, repository)
          new_object.name = 'object1'
          new_object.object_type_id = 'cmis:folder'
          expect {
            repository.root.create(new_object)
          }.to raise_exception
        end
      end
    end
  end
end
