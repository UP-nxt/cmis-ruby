require 'spec_helper'

module CMIS
  describe Object do
    before do
      @document = create_document
    end

    after do
      @document.delete
    end

    describe '#inspect' do
      REG_EXP = /CMIS::Document\[.*\] @ CMIS::Repository\[.*\] @ CMIS::Server\[.*\]/

      it 'displays not too much crap' do
        expect(@document.inspect).to match REG_EXP
      end
    end

    describe '#properties' do
      # Property accessor behavior...
    end

    describe '#object_type' do
      it 'returns the type' do
        expect(@document.object_type).to be_a CMIS::Type
        expect(@document.object_type.id).to eq('cmis:document')
      end
    end

    describe '#parents' do
      it 'has the root as only parent' do
        expect(@document.parents.size).to eq(1)
        expect(@document.parents.first.cmis_object_id).to eq(repository.root_folder_id)
      end
    end

    describe '#allowable_actions' do
      it 'returns the allowable actions' do
        actions = @document.allowable_actions
        expect(actions).to_not be_nil
        expect(actions).to_not be_empty
        actions.values.each do |v|
          expect([true, false]).to include(v)
        end
      end
    end

    describe '#relationships' do
      it 'returns all relationships' do
        relationships = @document.relationships
        expect(relationships).to be_a_kind_of(Relationships)
        relationships.each_relationship do |r|
          expect(r).to be_a(Relationship)
        end
      end
    end

    describe '#unfile' do
      it 'unfiles it from the parent folder' do
        @document.unfile
        expect(@document.parents).to be_empty
      end
    end

    describe '#acls' do
      it 'returns acls' do
        acls = @document.acls
        expect(acls).to have_key('aces')
        expect(acls).to have_key('isExact')
        expect([true, false]).to include(acls['isExact'])
      end
    end

    describe '#delete' do
      it 'deletes the document' do
        ephemeral_document = create_document
        ephemeral_document.delete

        expect {
          repository.object(ephemeral_document.cmis_object_id)
        }.to raise_exception(Exceptions::ObjectNotFound)
      end
    end

    describe '#delete_with_relationships' do
      it 'deletes the document and its relationships' do
        ephemeral_document = create_document

        rel = repository.new_relationship
        rel.object_type_id = 'cmis:relationship'
        rel.name = 'relationship'
        rel.source_id = ephemeral_document.cmis_object_id
        rel.target_id = ephemeral_document.cmis_object_id
        rel = rel.create

        ephemeral_document.delete_with_relationships

        expect {
          repository.object(ephemeral_document.cmis_object_id)
        }.to raise_exception(Exceptions::ObjectNotFound)

        expect {
          repository.object(rel.cmis_object_id)
        }.to raise_exception(Exceptions::ObjectNotFound)
      end
    end

    def create_document
      document = repository.new_document
      document.name = 'test_document'
      document.object_type_id = 'cmis:document'
      document.content = { stream: 'Apple is a fruit',
                           mime_type: 'text/plain',
                           filename: 'apple.txt' }
      repository.root.create(document)
    end
  end
end
