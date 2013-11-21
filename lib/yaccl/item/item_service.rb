module YACCL
  class ItemService
    
    def initialize(client)
      @client = client
    end

    def create_item(repository_id, item, succinct=false, policies=[], add_aces=[], remove_aces=[])
      required = {succinct: succinct,
                  cmisaction: 'createItem',
                  repositoryId: repository_id,
                  properties: item.to_hash}
      optional = {objectId: item.parent_id,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def update_item(repository_id, item)
      object_service = @client.object_service()
      result_hash = object_service.update_object(repository_id, item.id, item.to_hash, item.change_token)
      
      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def get_item(repository_id, item_id)
      object_service = @client.object_service()
      result_hash = object_service.get_object(repository_id, item_id)

      YACCL::Model::ObjectFactory.create(result_hash, repository_id, @client)
    end

    def delete_item(repository_id, item_id, all_versions=true, succinct=true)
      object_service = @client.object_service()
      object_service.delete_object(repository_id, item_id, all_versions, succinct)
    end

  end
end