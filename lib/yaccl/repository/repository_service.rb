module YACCL
  class RepositoryService

    def initialize(client)
      @client = client
    end

    # it's not CMIS standard to create a repository at all
    def create_repository(repo, succinct=false, policies=[], add_aces=[], remove_aces=[])
      meta = get_repository(Model::Repository::META_REPOSITORY_ID)

      required = {succinct: succinct,
                  cmisaction: 'createFolder',
                  repositoryId: meta.id,
                  properties: repo.to_hash,
                  objectId: meta.root_folder_id}
      optional = {policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      result_hash = @client.perform_request(required, optional)
      get_repository_from_hash(result_hash[:succinctProperties])
    end

    def get_repositories()
      result = @client.perform_request()
      repositories = []
      result.each do |repo_id, repo_h|
        repositories<<get_repository_from_hash(repo_h)
      end
      repositories
    end

    def get_repository(repository_id, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'repositoryInfo',
                  repositoryId: repository_id}
      response = @client.perform_request(required)

      repo = get_repository_from_hash(response[response.keys.first])
      repo
    end

    # it's not CMIS standard to delete a repository at all
    def delete_repository(repo_id, succinct=false, all_versions=false)
      required = {succinct: succinct,
                  cmisaction: 'delete',
                  repositoryId: Model::Repository::META_REPOSITORY_ID,
                  objectId: repo_id}
      optional = {allVersions: all_versions}
      @client.perform_request(required, optional)
    end

    private
      def get_repository_from_hash(hash)
        Model::Repository.create(hash)
      end

  end
end