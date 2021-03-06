require 'cmis/query'
require 'cmis/utils'
require 'json'

module CMIS
  class Repository
    attr_reader :server

    def initialize(raw, server)
      @hash = raw
      @hash.each_key do |key|
        self.class.class_eval "def #{key.as_ruby_property};@hash['#{key}'];end"
        self.class.class_eval "def #{key.gsub('repository', '').as_ruby_property};@hash['#{key}'];end" if key =~ /^repository/
      end

      @server = server
    end

    def new_document
      Document.new({}, self)
    end

    def new_folder
      Folder.new({}, self)
    end

    def new_relationship
      Relationship.new({}, self)
    end

    def new_item
      Item.new({}, self)
    end

    def new_policy
      Policy.new({}, self)
    end

    def new_type
      Type.new({}, self)
    end

    def root(opts = {})
      result = server.execute!({ cmisselector: 'object',
                                 repositoryId: id,
                                 objectId: root_folder_id }, opts)

      ObjectFactory.create(result, self)
    end

    def object(cmis_object_id, opts = {})
      result = server.execute!({ cmisselector: 'object',
                                 repositoryId: id,
                                 objectId: cmis_object_id }, opts)

      ObjectFactory.create(result, self)
    end

    def type_tree(opts = {})
      server.execute!({ cmisselector: 'typeDescendants',
                        repositoryId: id,
                        includePropertyDefinitions: false }, opts)
    end

    def types(opts = {})
      result = server.execute!({ cmisselector: 'typeDescendants',
                                 repositoryId: id,
                                 includePropertyDefinitions: true }, opts)

      construct_types(result)
    end

    def type(type_id, opts = {})
      result = server.execute!({ cmisselector: 'typeDefinition',
                                 repositoryId: id,
                                 typeId: type_id }, opts)

      Type.new(result, self)
    end

    def type?(type_id)
      type(type_id)
      true
    rescue Exceptions::ObjectNotFound
      false
    end

    def create_type(type, opts = {})
      type.create(opts)
    end

    def create_relationship(object, opts = {})
      raise 'Object is not a Relationship' unless object.is_a?(Relationship)

      result = server.execute!({ cmisaction: 'createRelationship',
                                 repositoryId: id,
                                 properties: object.properties }, opts)

      ObjectFactory.create(result, self)
    end

    def content_changes(change_log_token, opts = {})
      server.execute!({ cmisselector: 'contentChanges',
                        repositoryId: id,
                        changeLogToken: change_log_token }, opts)
    end

    def query(statement, opts = {})
      Query.new(self, statement, opts)
    end

    def find_object(type_id, properties = {}, opts = {})
      opts.merge!(page_size: 1)
      statement = Utils.build_query_statement(type_id, properties)
      query(statement, opts).results.first
    end

    def count_objects(type_id, properties = {}, opts = {})
      opts.merge!(page_size: 0)
      statement = Utils.build_query_statement(type_id, properties, 'cmis:objectId')
      query(statement, opts).total
    end

    # Returns the changed objects
    def update_objects(type_id, conditions, properties)
      statement = Utils.build_query_statement(type_id, conditions, 'cmis:objectId', 'cmis:changeToken')
      object_ids_and_change_tokens = []
      query(statement).each_result(limit: :all) do |r|
        object_ids_and_change_tokens << [r.cmis_object_id, r.change_token]
      end
      if object_ids_and_change_tokens.empty?
        []
      else
        results = []
        object_ids_and_change_tokens.each_slice(10) do |part|
          r = server.execute!({ cmisaction: 'bulkUpdate',
                                repositoryId: id,
                                objectIdAndChangeToken: part,
                                properties: properties })
          r.map! do |h|
            object = CMIS::Object.new({}, self)
            object.cmis_object_id = h['id']
            object
          end
          results.concat(r)
        end
        results
      end
    end

    def bulk_update_objects(object_ids_and_change_tokens, properties)
      server.execute!(cmisaction: 'bulkUpdate',
                      repositoryId: id,
                      objectIdAndChangeToken: object_ids_and_change_tokens,
                      properties: properties)
    end

    def inspect
      "#{self.class}[#{id}] @ #{server.inspect}"
    end

    private

    def construct_types(a)
      types = []
      a.each do |t|
        types << Type.new(t['type'], self)
        types << construct_types(t['children']) if t.key?('children')
      end
      types.flatten
    end
  end
end
