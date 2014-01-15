module YACCL
  module ObjectServices
    def get_object(repository_id, cmis_object_id, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'object',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {filter: filter,
                  includeAllowableActions: include_allowable_actions,
                  includeRelationships: include_relationships,
                  renditionFilter: rendition_filter,
                  includePolicyIds: include_policy_ids,
                  includeAcl: include_acl}
      perform_request(required, optional)
    end

    def get_properties(repository_id, cmis_object_id, filter, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'properties',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {filter: filter}
      perform_request(required, optional)
    end

    def create_document(repository_id, properties, folder_id, content, versioning_state, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createDocument',
                  repositoryId: repository_id,
                  properties: properties,
                  objectId: folder_id}
      optional = {folderId: folder_id,
                  content: content,
                  versioningState: versioning_state,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def create_document_from_source(repository_id, source_id, properties, folder_id, versioning_state, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createDocument',
                  repositoryId: repository_id,
                  sourceId: source_id}
      optional = {properties: properties,
                  objectId: folder_id,
                  versioningState: versioning_state,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def create_folder(repository_id, properties, folder_id, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createFolder',
                  repositoryId: repository_id,
                  properties: properties,
                  objectId: folder_id}
      optional = {policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def create_relationship(repository_id, properties, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createRelationship',
                  repositoryId: repository_id,
                  properties: properties}
      optional  = {policies: policies,
                   addACEs: add_aces,
                   removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def create_policy(repository_id, properties, folder_id, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createPolicy',
                  repositoryId: repository_id,
                  properties: properties}
      optional = {objectId: folder_id,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def create_item(repository_id, properties, folder_id, policies, add_aces, remove_aces, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'createItem',
                  repositoryId: repository_id,
                  properties: properties}
      optional = {objectId: folder_id,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def get_allowable_actions(repository_id, cmis_object_id, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'allowableActions',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      perform_request(required)
    end

    def get_renditions(repository_id, cmis_object_id, rendition_filter, max_items, skip_count, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'renditions',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {renditionFilter: rendition_filter,
                  maxItems: max_items,
                  skipCount: skip_count}
      perform_request(required, optional)
    end

    def get_object_by_path(repository_id, path, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, succinct=false)
      raise 'Not supported.'
    end

    def get_content_stream(repository_id, cmis_object_id, stream_id, offset, length, succinct=false)
      required = {succinct: succinct,
                  cmisselector: 'content',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {streamId: stream_id,
                  offset: offset,
                  length: length}
      perform_request(required, optional)
    end

    def update_properties(repository_id, cmis_object_id, change_token, properties, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'update',
                  repositoryId: repository_id,
                  objectId: cmis_object_id,
                  properties: properties}
      optional = {changeToken: change_token}
      perform_request(required, optional)
    end

    def bulk_update_properties(repository_id, cmis_object_ids_and_change_tokens, properties, add_secondary_type_ids, remove_secondary_type_ids, succinct=false)
      # TODO
    end

    def move_object(repository_id, cmis_object_id, target_folder_id, source_folder_id, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'move',
                  repositoryId: repository_id,
                  objectId: cmis_object_id,
                  targetFolderId: target_folder_id,
                  sourceFolderId: source_folder_id}
      perform_request(required)
    end

    def delete_object(repository_id, cmis_object_id, all_versions, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'delete',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {allVersions: all_versions}
      perform_request(required, optional)
    end

    def delete_tree(repository_id, folder_id, all_versions, unfile_objects, continue_on_failure, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'deleteTree',
                  repositoryId: repository_id,
                  objectId: folder_id}
      optional = {allVersions: all_versions,
                  unfileObjects: unfile_objects,
                  continueOnFailure: continue_on_failure}
      perform_request(required, optional)
    end

    def set_content_stream(repository_id, cmis_object_id, overwrite_flag, change_token, content, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'setContent',
                  repositoryId: repository_id,
                  objectId: cmis_object_id,
                  content: content}
      optional = {overwriteFlag: overwrite_flag,
                  changeToken:change_token}
      perform_request(required, optional)
    end

    def delete_content_stream(repository_id, cmis_object_id, change_token, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'deleteContent',
                  repositoryId: repository_id,
                  objectId: cmis_object_id}
      optional = {changeToken: change_token}
      perform_request(required, optional)
    end

    def append_content_stream(repository_id, cmis_object_id, change_token, content, is_last_chunk, succinct=false)
      required = {succinct: succinct,
                  cmisaction: 'appendContent',
                  repositoryId: repository_id,
                  objectId: cmis_object_id,
                  content: content}
      optional = {isLastChunk: is_last_chunk,
                  changeToken: change_token}
      perform_request(required, optional)
    end
  end
end
