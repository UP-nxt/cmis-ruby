require 'spec_helper'

module CMIS
  describe Document do
    context 'when creating a document with content' do
      it 'has properties and content' do
        document = repository.new_document
        document.name = 'apple_document'
        document.object_type_id = 'cmis:document'
        document.content = { stream: StringIO.new('apple is a fruit'),
                             mime_type: 'text/apple',
                             filename: 'apple.txt' }
        document = document.create_in_folder(repository.root)

        expect(document.content_stream_mime_type).to eq('text/apple')
        expect(document.content_stream_file_name).to eq('apple.txt')
        expect(document.content).to eq('apple is a fruit')

        document.delete
      end
    end

    context 'when creating a document without content' do
      it 'has properties and no content' do
        document = repository.new_document
        document.name = 'apple_document'
        document.object_type_id = 'cmis:document'
        document = document.create_in_folder(repository.root)

        expect(document.content_stream_mime_type).to be_nil
        expect(document.content_stream_file_name).to be_nil
        expect(document.content).to be_nil

        document.delete
      end
    end

    context 'when creating a document and then setting the content' do
      it 'has properties and content' do
        document = repository.new_document
        document.name = 'apple_document'
        document.object_type_id = 'cmis:document'
        document = document.create_in_folder(repository.root)

        document.content = { stream: StringIO.new('apple is a fruit'),
                             mime_type: 'text/apple',
                             filename: 'apple.txt' }

        # Why doesn't this work?
        # expect(document.content_stream_mime_type).to eq('text/apple')
        # expect(document.content_stream_file_name).to eq('apple.txt')
        expect(document.content).to eq('apple is a fruit')

        document.delete
      end
    end
  end
end
