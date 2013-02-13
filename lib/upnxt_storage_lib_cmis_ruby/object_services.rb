require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class ObjectServices
    def get_object(repository_id, object_id, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
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

    def get_properties(repository_id, object_id, filter, extension={})
      query = {
        cmisselector: 'properties',
        objectId: object_id,
        filter: filter
      }
      BrowserBindingService.get("/#{repository_id}/root", query: query)
    end

    def create_document(repository_id, properties, folder_id, content_stream, versioning_state, policies, add_aces, remove_aces, extension={})
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

    def create_document_from_source(repository_id, source_id, properties, folder_id, versioning_state, policies, add_aces, remove_aces, extension={})
      # TODO
    end

    def create_folder(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      body = {
        cmisaction: 'createFolder',
        objectId: folder_id,
        properties: properties,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}/root", body: body)
    end

    def create_relationship(repository_id, properties, policies, add_aces, remove_aces, extension={})
      body = {
        cmisaction: 'createRelationship',
        properties: properties,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}", body: body)
    end

    def create_policy(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      body = {
        cmisaction: 'createPolicy',
        properties: properties,
        folderId: folder_id,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}", body: body)
    end

    def create_item(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      body = {
        cmisaction: 'createItem',
        properties: properties,
        folderId: folder_id,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      BrowserBindingService.multipart_post("/#{repository_id}", body: body)
    end

    def get_allowable_actions(repository_id, object_id, extension={})
      # TODO
    end

    def get_renditions(repository_id, object_id, rendition_filter, max_items, skip_count, extension={})
      # TODO
    end

    def get_object_by_path(repository_id, path, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
      # TODO
    end

    def get_content_stream(repository_id, object_id, stream_id, offset, length, extension={})
      query = {
        cmisselector: 'content',
        objectId: object_id,
        streamId: stream_id,
        offset: offset,
        length: length
      }
      BrowserBindingService.get("/#{repository_id}/root", query: query)
    end

    def update_properties(repository_id, object_id, change_token, properties, extension={})
      # TODO
    end

    def bulk_update_properties(repository_id, object_ids_and_change_tokens, properties, add_secondary_type_ids, remove_secondary_type_ids, extension={})
      # TODO
    end

    def move_object(repository_id, object_id, target_folder_id, source_folder_id, extension={})
      # TODO
    end

    def delete_object(repository_id, object_id, all_versions, extension={})
      # TODO
    end

    def delete_tree(repository_id, folder_id, all_versions, unfile_objects, continue_on_failure, extension={})
      # TODO
    end

    def set_content_stream(repository_id, object_id, overwrite_flag, change_token, content_stream, extension={})
      # TODO
    end

    def delete_content_stream(repository_id, object_id, change_token, extension={})
      # TODO
    end

    def append_content_stream(repository_id, object_id, change_token, content_stream, is_last_chunk, extension={})
      # TODO
    end
  end
end


# services = UpnxtStorageLibCmisRuby::ObjectServices.new
# puts services.get_properties('blueprint', 'fdul26ye4wlmcrercztw6oup2ry', nil).body
# puts services.create_document('blueprint',
#                               { 'cmis:name' => 'L1 Document', 'cmis:objectTypeId' => 'cmis:document', 'upn:body' => 'Lalala' },
#                               'fb4jwpirlh64hekiqltelq6zav4',
#                               UploadIO.new(StringIO.new('Lorem ipsum...'), 'text/plain', 'lorem.txt'),
#                               nil, nil, nil, nil).body
# puts services.create_folder('blueprint',
#                             { 'cmis:name' => 'L2 Folder (bis)', 'cmis:objectTypeId' => 'cmis:folder' },
#                             'fb4jwpirlh64hekiqltelq6zav4',
#                             nil, nil, nil).body
# puts services.create_relationship('blueprint',
#                                   { 'cmis:name' => 'Relation X', 'cmis:objectTypeId' => 'cmis:relationship', 'cmis:sourceId' => 'dayj2o53aj5w3ubfkjz4wn4hpki', 'cmis:targetId' => 'dg62lj2jtppxytxtu74bovfalfi' },
#                                   nil, nil, nil).body
# puts services.get_content_stream('blueprint', 'dhvxd4hgplkq32xw2edkiiu23oy', nil, nil, nil).body
