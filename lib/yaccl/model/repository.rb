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

      def ==(other)
        return true if other.equal?(self)
        return false unless other.kind_of?(self.class)
        id == other.id
      end

      def to_s
        name
      end

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

      def object(cmis_object_id)
        ObjectFactory.create(id, Services.get_object(id, cmis_object_id, nil, false, nil, nil, false, false))
      end

      # type

      def type(type_id)
        Type.create(id, Services.get_type_definition(id, type_id))
      end

      def types
        _types(Services.get_type_descendants(id, nil, nil, true))
      end

      def create_type(type)
        Type.create(id, Services.create_type(id, type.to_hash))
      end

      # relationship

      def create(object)
        properties = object.create_properties
        if object.is_a? Folder
          raise 'create object in folder'
        elsif object.is_a? Document
          raise 'create document in folder'
        elsif object.is_a? Relationship
          o = Services.create_relationship(id, properties, nil, nil, nil)
        elsif object.is_a? Policy
          raise 'create policy in folder'
        elsif object.is_a? Item
          raise 'create item in folder'
        else
          raise "Unexpected base_type_id: #{object.base_type_id}"
        end
        ObjectFactory.create(id, o)
      end

      # discovery

      def query(statement, max_items=nil, skip_count=nil, &block)
        result = Services.query(id, statement, nil, nil, nil, nil, max_items, skip_count)
        result[:results].map! { |o| ObjectFactory.create(id, o) }
        result[:num_items] = result.delete(:numItems)
        result[:has_more_items] = result.delete(:hasMoreItems)

        yield(result) if block_given?
        result[:results]
      end

      def query_for_each_chunk(statement, chunk_size, &block)
        skip_count = 0
        has_more_items = true
        while has_more_items
          result = Services.query(id, statement, nil, nil, nil, nil, chunk_size, skip_count)
          yield(result[:results].map! { |o| ObjectFactory.create(id, o) })
          has_more_items = result[:hasMoreItems]
          skip_count += chunk_size
        end
      end

      def content_changes(change_log_token)
        Services.get_content_changes(id, change_log_token, nil, nil, nil, nil)
      end

      private

      def _types(arr)
        types = []
        arr.each do |t|
          types << Type.create(id, t[:type])
          types << _types(t[:children]) if t.has_key?(:children)
        end
        types.flatten
      end
    end
  end
end
