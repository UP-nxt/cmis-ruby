require 'spec_helper'

module CMIS
  describe Relationship do
    before :all do
      cleanup_relationships
      @document = create_document
    end

    after :all do
      @document.delete
    end

    context 'when deleting relationships with sourceId and targetId pointing to same document' do
      before :each do
        40.times { create_relationship(@document.cmis_object_id, @document.cmis_object_id) }
      end

      after :each do
        cleanup_relationships
      end

      it 'deletes all relationships via document' do
        loop do
          results = @document.relationships.results
          break if results.size == 0
          results.each { |rel| rel.delete }
        end

        expect(count_relationships).to eq(0)
      end

      it 'deletes all relationships via query' do
        loop do
          results = repository.query("select * from cmis:relationship").results
          break if results.size == 0
          results.each { |rel| rel.delete}
        end
        expect(count_relationships).to eq(0)
      end

      it 'deletes all relationships after retrieving them' do
        cleanup_relationships
        expect(count_relationships).to eq(0)
      end
    end

    def create_relationship(source_id, target_id)
      new_object = repository.new_relationship
      new_object.name = "doc_#{source_id}"
      new_object.object_type_id = 'cmis:relationship'
      new_object.source_id = source_id
      new_object.target_id = target_id
      repository.create_relationship(new_object)
    end

    def create_document
      document = repository.new_document
      document.name = 'apple_document'
      document.object_type_id = 'cmis:document'
      document.create_in_folder(repository.root)
    end

    def cleanup_relationships
      results = []
      repository.query("select * from cmis:relationship").each_result(limit: :all) { | rel | results << rel}
      results.each { |rel| rel.delete }
    end

    def count_relationships
      count = 0
      repository.query("select cmis:objectId from cmis:relationship").each_result(limit: :all) { | rel | count += 1}
      count
    end
  end
end
