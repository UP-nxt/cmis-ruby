def create_repository(id)
  meta = UpnxtStorageLibCmisRuby::Model::Service.repository('meta')
  f = meta.new_folder
  f.name = id
  f.object_type_id = 'repository'
  f.properties['supportsRelationships'] = true
  f.properties['supportsPolicies'] = true
  f.properties['supportsItem'] = true
  meta.root.create(f)
  UpnxtStorageLibCmisRuby::Model::Service.repository(id)
end

def delete_repository(id)
  meta = UpnxtStorageLibCmisRuby::Model::Service.repository('meta')
  meta.object(id).delete
end
