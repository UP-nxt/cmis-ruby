require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class ObjectServices
    def get_object(repository_id, object_id, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension = {})
      query = {
        cmisselector: 'object',
        objectId: object_id,
        filter: filter,
        includeAllowableActions: include_allowable_actions,
        includeRelationships: include_relationships,
        renditionFilter: rendition_filter,
        includePolicyIds: include_policy_ids,
        includeAcl: include_acl
      }
      BrowserBindingService.get("/#{repository_id}/root", query: query)
    end

    def get_properties(repository_id, object_id, filter, extension = {})
      query = {
        cmisselector: 'properties',
        objectId: object_id,
        filter: filter
      }
      BrowserBindingService.get("/#{repository_id}/root", query: query)
    end

    def create_document(repository_id, properties, folder_id, content_stream, versioning_state, policies, add_aces, remove_aces, extension = {})
      body = {
        cmisaction: 'createDocument',
        objectId: folder_id, # In the example this is a query param, however this doesn't seem to work
        properties: properties,
        contentStream: content_stream,
        versioningState: versioning_state,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}/root", body: body)
    end

    def create_document_from_source(repository_id, source_id, properties, folder_id, versioning_state, policies, add_aces, remove_aces, extension = {})
    end

    def create_folder(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension = {})
      body = {
        cmisaction: 'createFolder',
        properties: properties,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}/root?objectId=#{folder_id}", body: body)
    end

    def create_relationship(repository_id, properties, policies, add_aces, remove_aces, extension = {})
    end

    def create_policy(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension = {})
    end

    def create_item(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension = {})
    end

    def get_allowable_actions(repository_id, object_id, extension = {})
    end

    def get_renditions(repository_id, object_id, rendition_filter, max_items, skip_count, extension = {})
    end

    def get_object_by_path(repository_id, path, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension = {})
    end

    def get_content_stream(repository_id, object_id, stream_id, offset, length, extension = {})
    end

    def update_properties(repository_id, object_id, change_token, properties, extension = {})
    end

    def bulk_update_properties(repository_id, object_ids_and_change_tokens, properties, add_secondary_type_ids, remove_secondary_type_ids, extension = {})
    end

    def move_object(repository_id, object_id, target_folder_id, source_folder_id, extension = {})
    end

    def delete_object(repository_id, object_id, all_versions, extension = {})
    end

    def delete_tree(repository_id, folder_id, all_versions, unfile_objects, continue_on_failure, extension = {})
    end

    def set_content_stream(repository_id, object_id, overwrite_flag, change_token, content_stream, extension = {})
    end

    def delete_content_stream(repository_id, object_id, change_token, extension = {})
    end

    def append_content_stream(repository_id, object_id, change_token, content_stream, is_last_chunk, extension = {})
    end
  end
end

# services = UpnxtStorageLibCmisRuby::ObjectServices.new
# puts services.create_document('blueprint',
#                               { 'cmis:name' => 'L1 Document', 'cmis:objectTypeId' => 'cmis:document' },
#                               'fbqtad6cjfyaufo2unrwmyoacqy',
#                               UploadIO.new(StringIO.new('Lorem ipsum...'), 'text/plain', 'lorem.txt'),
#                               nil, nil, nil, nil).body
# puts services.create_folder('blueprint', { 'cmis:name' => 'L1 Folder', 'cmis:objectTypeId' => 'cmis:folder' }, 'fdul26ye4wlmcrercztw6oup2ry', nil, nil, nil).body
# puts services.get_properties('blueprint', 'fdul26ye4wlmcrercztw6oup2ry', nil).body
# puts services.get_object('blueprint', 'dion2fc2w25vhrngsbla6ct6y4i', nil, nil, nil, nil, nil, nil).body
