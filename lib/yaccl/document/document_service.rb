module YACCL
  class DocumentService

    def initialize(client)
      @client = client
    end

    def create_document(repository_id, folder, versioning_state=nil, policies=nil, add_aces=nil, remove_aces=nil, succinct=false)
      folder.parent_id = get_root_folder_id(repository_id) if folder.parent_id.nil?

      required = {succinct: succinct,
                  cmisaction: 'createDocument',
                  repositoryId: repository_id,
                  properties: folder.to_hash,
                  objectId: folder.parent_id}
      optional = {folderId: folder.parent_id,
                  content: folder.content,
                  versioningState: versioning_state,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def update_document(repository_id, document)
      object_service = @client.object_service()
      result_hash = object_service.update_object(repository_id, document.id, document.to_hash, document.change_token)
      
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_document(repository_id, document_id)
      object_service = @client.object_service()
      result_hash = object_service.get_object(repository_id, document_id)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def delete_document(repository_id, document_id, all_versions=true, succinct=true)
      object_service = @client.object_service()
      object_service.delete_object(repository_id, document_id, all_versions, succinct)
    end

    def save_content_stream(repository_id, object_id, content, change_token, overwrite_flag = nil, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'setContent',
                  repositoryId: repository_id,
                  objectId: object_id,
                  content: content}
      optional = {overwriteFlag: overwrite_flag,
                  changeToken:change_token}
      result_hash = @client.perform_request(required, optional)
      
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_content_stream(repository_id, object_id, stream_id=nil , offset=nil, length=nil, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'content',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {streamId: stream_id,
                  offset: offset,
                  length: length}
      @client.perform_request(required, optional)
    end

    def delete_content_stream(repository_id, object_id, change_token = 1, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'deleteContent',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {changeToken: change_token}
      @client.perform_request(required, optional)
    end

    def append_content_stream(repository_id, object_id, content, change_token, is_last_chunk, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'appendContent',
                  repositoryId: repository_id,
                  objectId: object_id,
                  content: content}
      optional = {isLastChunk: is_last_chunk,
                  changeToken: change_token}
      @client.perform_request(required, optional)
    end

    private 
      def get_root_folder_id(repo_id)
        repository_service = @client.repository_service()
        repository = repository_service.get_repository(repo_id)
        repository.root_folder_id
      end

  end
end