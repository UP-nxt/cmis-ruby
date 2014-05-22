require 'spec_helper'

module CMIS
  describe CMIS::Query do
    before :all do
      @folder = create_folder
      21.times { create_document }
    end

    after :all do
      @folder.delete_tree
    end

    context 'when querying with a limit' do
      it 'should execute only one query if limit is under 10' do
        CMIS::Query.any_instance.stub(:do_query).and_call_original

        result = documents_query_result(limit: 3)
        expect(result.size).to eq(3)

        @query.should have_received(:do_query).exactly(1).times
      end

      it 'should execute only 2 queries if limit is 20' do
        CMIS::Query.any_instance.stub(:do_query).and_call_original

        result = documents_query_result(limit: 20)
        expect(result.size).to eq(20)

        @query.should have_received(:do_query).exactly(2).times
      end

      it 'should receive 5 documents if limit is 5' do
        result = documents_query_result(limit: 5)
        expect(result.size).to eq(5)
      end
    end

    def create_folder
      folder = repository.new_folder
      folder.name = 'test_query'
      folder.object_type_id = 'cmis:folder'
      repository.root.create(folder)
    end

    def create_document
      document = repository.new_document
      document.name = 'apple_document'
      document.object_type_id = 'cmis:document'
      document.create_in_folder(@folder)
    end

    def documents_query_result(opts)
      results = []
      query_string = "select cmis:objectId from cmis:document" \
        " where IN_FOLDER('#{@folder.cmis_object_id}')"
      @query = repository.query(query_string)
      @query.each_result(opts) { |r| results << r }
      results
    end
  end
end
