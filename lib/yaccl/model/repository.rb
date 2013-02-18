module YACCL
  module Model
    class Repository
      attr_reader :id
      attr_reader :name
      attr_reader :description
      attr_reader :root_folder_id
      attr_reader :capabilities
      attr_reader :url
      attr_reader :latest_change_log_token
      attr_reader :vendor_name
      attr_reader :cmis_version_supported
      attr_reader :acl_capabilities
      attr_reader :product_name
      attr_reader :product_version
      attr_reader :thin_client_uri
      attr_reader :changes_on_type
      attr_reader :root_folder_url

      def self.create(raw_repository)
        Repository.new(raw_repository)
      end

      def initialize(raw)
        @id = raw[:repositoryId]
        @name = raw[:repositoryName]
        @description = raw[:repositoryDescription]
        @root_folder_id = raw[:rootFolderId]
        @capabilities = raw[:capabilities]
        @url = raw[:repositoryUrl]
        @latest_change_log_token = raw[:latestChangeLogToken]
        @vendor_name = raw[:vendorName]
        @cmis_version_supported = raw[:cmisVersionSupported]
        @acl_capabilities = raw[:aclCapabilities]
        @product_name = raw[:productName]
        @product_version = raw[:productVersion]
        @thin_client_uri = raw[:thinClientUri]
        @changes_on_type = raw[:changesOnType]
        @root_folder_url = raw[:rootFolderUrl]
      end

      def new_folder
        Folder.new(id)
      end

      def new_document
        Document.new(id)
      end

      def new_relationship
        Relationship.new(id)
      end

      def new_policy
        Policy.new(id)
      end

      def new_item
        Item.new(id)
      end

      # object

      def root
        ObjectFactory.create(id, Services.get_object(id, root_folder_id, nil, false, nil, nil, false, false))
      end

      def object(object_id)
        ObjectFactory.create(id, Services.get_object(id, object_id, nil, false, nil, nil, false, false))
      end

      # type

      def type(type_id)
        Type.create(Services.get_type_definition(id, type_id))
      end

      def type_tree

      end

      def create_type(type)
        Type.create(Services.create_type(id, type.to_hash))
      end

      def update_type(type)
        Type.create(Services.update_type(id, type.to_hash))
      end

      def delete_type(type_id)
        Services.delete_type(id, type_id)
      end

      # discovery

      def query(statement)
        Services.query(id, statement, false, nil, nil, nil, nil, nil).map do |o|
          ObjectFactory.create(id, o)
        end
      end

      def content_changes(change_log_token)
        Services.get_content_changes(id, change_log_token, nil, nil, nil, nil)
      end
    end
  end
end
