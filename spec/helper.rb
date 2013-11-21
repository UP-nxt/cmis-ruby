require 'yaccl'
require 'json'

def create_repository()
  repo = Repository.new()
  repo[:id]='test_repo'

  repository_service.create(repo)
end

def destroy_repository()
  repository_service.delete('test_repo')
end

$SERVER = 'http://localhost:8080/browser'
$USER = 'metaadmin'
$PASSWORD = 'metaadmin'