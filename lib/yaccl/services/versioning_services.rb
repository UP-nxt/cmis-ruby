module YACCL
  module VersioningServices
    def check_out(repository_id, object_id, content_copied, extension={})
    end

    def cancel_check_out(repository_id, object_id, extension={})
    end

    def check_in(repository_id, object_id, major, properties, content_stream, checkin_comment, policies, add_aces, remove_aces, extension={})
    end

    def get_object_of_latest_version(repository_id, object_id, version_series_id, major, filter, include_allowable_actions, include_relationships, rendition_filter, include_policy_ids, include_acl, extension={})
    end

    def get_properties_of_latest_version(repository_id, object_id, version_series_id, major, filter, extension={})
    end

    def get_all_versions(repository_id, object_id, version_series_id, filter, include_allowable_actions, extension={})
    end
  end
end
