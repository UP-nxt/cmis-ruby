module YACCL
  module VersioningServices  # TODO Check 'version_series_id' confusion.
    def check_out(repository_id, object_id, extension={})
      required = {cmisaction: 'checkOut',
                  repositoryId: repository_id,
                  objectId: object_id}
      perform_request(required)
    end

    def cancel_check_out(repository_id, object_id, extension={})
      required = {cmisaction: 'cancelCheckOut',
                  repositoryId: repository_id,
                  objectId: object_id}
      perform_request(required)
    end

    def check_in(repository_id, object_id, major, properties, content, checkin_comment, policies, add_aces, remove_aces, extension={})
      required = {cmisaction: 'checkIn',
                  repositoryId: repository_id,
                  objectId: object_id}
      optional = {major: major,
                  properties: properties,
                  content: content,
                  checkinComment: checkin_comment,
                  policies: policies,
                  addACEs: add_aces,
                  removeACEs: remove_aces}
      perform_request(required, optional)
    end

    def get_object_of_latest_version(repository_id, version_series_id, major, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
      required = {cmisselector: 'object',
                  repositoryId: repository_id,
                  objectId: version_series_id}
      optional = {major: major,
                  filter: filter,
                  includeAllowableActions: include_allowable_actions,
                  includeRelationships: include_relationships,
                  renditionFilter: rendition_filter,
                  includePolicyIds: include_policy_ids,
                  includeACL: include_acl}
      perform_request(required, optional)
    end

    def get_properties_of_latest_version(repository_id, version_series_id, major, filter, extension={})
      required = {cmisselector: 'properties',
                  repositoryId: repository_id,
                  objectId: version_series_id}
      optional = {major: major,
                  filter: filter}
      perform_request(required, optional)
    end

    def get_all_versions(repository_id, version_series_id, filter, include_allowable_actions, extension={})
      required = {cmisselector: 'versions',
                  repositoryId: repository_id,
                  objectId: version_series_id}
      optional = {filter: filter,
                  includeAllowableActions: include_allowable_actions}
      perform_request(required, optional)
    end
  end
end
