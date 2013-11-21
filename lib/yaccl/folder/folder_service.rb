module YACCL
  class FolderService
    def initialize(client)
      @client = client
    end

    def create(repository_id, folder, succinct=true, policies=[], add_aces=[], remove_aces=[])
      required = {succinct: succinct,
                  cmisaction: 'createFolder',
                  repositoryId: repository_id,
                  properties: folder.to_hash,
                  objectId: folder.parent_id}
      optional = {policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_folder(repository_id, folder_id)
      object_service = @client.object_service()
      result_hash = object_service.get_object(repository_id, folder_id)
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_all_folders(repository_id)
      folders = Array.new()
      results = @client.query(repository_id, 'SELECT * FROM cmis:folder')
      results[:results].each do |folder_hash| 
        f = YACCL::Model::ObjectFactory.create(folder_hash, repository_id, @client)
        folders<<f
      end
      folders
    end

    def update_folder(repository_id, folder)
      @client.object_service().update_object(repository_id, folder.id, folder.to_hash, folder.change_token)
    end

    def delete_by_folder_id(repository_id, folder_id)
      @client.object_service().delete_object(repository_id, folder_id, true)
    end

    def delete_folder(folder)
      delete_by_folder_id(folder.repository_id, folder.id)
    end

  end
end