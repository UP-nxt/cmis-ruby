require_relative 'browser_binding_service'

module UpnxtStorageLibCmisRuby
  class ObjectServices
    def initialize(service_url)
      @service = BrowserBindingService.new(service_url)
    end

    def get_object(repository_id, object_id, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
      params = {
        cmisselector: 'object',
        objectId: object_id,
        filter: filter,
        includeAllowableActions: include_allowable_actions,
        includeRelationships: include_relationships,
        renditionFilter: rendition_filter,
        includePolicyIds: include_policy_ids,
        includeAcl: include_acl
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def get_properties(repository_id, object_id, filter, extension={})
      params = {
        cmisselector: 'properties',
        objectId: object_id,
        filter: filter
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def create_document(repository_id, properties, folder_id, content, versioning_state, policies, add_aces, remove_aces, extension={})
      params = {
        cmisaction: 'createDocument',
        properties: properties,
        versioningState: versioning_state,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces,
      }
      params[:content] = UploadIO.new(content[:stream], content[:mime_type], content[:filename]) unless content.nil?
      if folder_id.nil?
        @service.perform_request("/#{repository_id}", params)
      else
        @service.perform_request("/#{repository_id}/root", params.merge(objectId: folder_id))
      end
    end

    def create_document_from_source(repository_id, source_id, properties, folder_id, versioning_state, policies, add_aces, remove_aces, extension={})
      raise 'Not supported.'
    end

    def create_folder(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      params = {
        cmisaction: 'createFolder',
        objectId: folder_id,
        properties: properties,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def create_relationship(repository_id, properties, policies, add_aces, remove_aces, extension={})
      params = {
        cmisaction: 'createRelationship',
        properties: properties,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def create_policy(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      params = {
        cmisaction: 'createPolicy',
        properties: properties,
        folderId: folder_id,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def create_item(repository_id, properties, folder_id, policies, add_aces, remove_aces, extension={})
      params = {
        cmisaction: 'createItem',
        properties: properties,
        folderId: folder_id,
        policies: policies,
        addACEs: add_aces,
        removeACEs: remove_aces
      }
      @service.perform_request("/#{repository_id}", params)
    end

    def get_allowable_actions(repository_id, object_id, extension={})
      params = {
        cmisselector: 'allowableActions',
        objectId: object_id,
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def get_renditions(repository_id, object_id, rendition_filter, max_items, skip_count, extension={})
      params = {
        cmisselector: 'renditions',
        objectId: object_id,
        renditionFilter: rendition_filter,
        maxItems: max_items,
        skipCount: skip_count
      }
      @service.perform_request("/#{repository_id}/root", params)
    end

    def get_object_by_path(repository_id, path, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
      raise 'Not supported.'
    end

    def get_content_stream(repository_id, object_id, stream_id, offset, length, extension={})
      params = {
        cmisselector: 'content',
        objectId: object_id,
        streamId: stream_id,
        offset: offset,
        length: length
      }
      @service.perform_request("/#{repository_id}/root", params)
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
