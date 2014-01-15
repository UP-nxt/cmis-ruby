module YACCL
  module MultiFilingServices
    def add_object_to_folder(repository_id, cmis_object_id, folder_id, all_versions, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'addObjectToFolder',
                  repositoryId: repository_id,
                  objectId: cmis_object_id,
                  folderId: folder_id}
      optional = {allVersions: all_versions}
      perform_request(required, optional)
    end

    def remove_object_from_folder(repository_id, cmis_object_id, folder_id, succinct=false)
      required = {succinct: succinct,
                  repositoryId: repository_id,
                  cmisaction: 'removeObjectFromFolder',
                  objectId: cmis_object_id}
      optional = {folderId: folder_id}
      perform_request(required, optional)
    end
  end
end
