require 'yaccl/browser_binding_service'
require 'yaccl/object_factory'

module YACCL
  class CmisClient
    attr_accessor :service_url
    attr_accessor :basic_auth_username
    attr_accessor :basic_auth_password
    attr_accessor :succint_properties
    attr_accessor :cache

    @cache = SimpleCache::MemoryCache.new()

    def initialize(service_url, basic_auth_username=nil, basic_auth_password=nil, succint_properties=true)
      @service_url=service_url
      @basic_auth_username=basic_auth_username
      @basic_auth_password=basic_auth_password
      @succint_properties=succint_properties
    end

    def repository_service()
      @repository_service = RepositoryService.new(self) unless @repository_service
      @repository_service
    end

    def folder_service()
      @folder_service = FolderService.new(self) unless @folder_service
      @folder_service
    end

    def document_service()
      @document_service = DocumentService.new(self) unless @document_service
      @document_service
    end

    def item_service()
      @item_service = ItemService.new(self) unless @item_service
      @item_service
    end

    def type_service()
      @type_service = TypeService.new(self) unless @type_service
      @type_service
    end

    def object_service()
      @object_service = ObjectService.new(self) unless @object_service
      @object_service
    end

    def acl_service()
      @acl_service = AclService.new(self) unless @acl_service
      @acl_service
    end
    
    def policy_service()
      @policy_service = PolicyService.new(self) unless @policy_service
      @policy_service
    end

    def relationship_service()
      @relationship_service = RelationshipService.new(self) unless @relationship_service
      @relationship_service
    end

    def perform_request(required = {}, optional = {})
      required = duplicate_object(required)
      optional = duplicate_object(optional)

      @service = Internal::BrowserBindingService.new(@service_url, @basic_auth_username, @basic_auth_password, @succint_properties) unless @service
      
      required, optional = Validator::validate_and_fix_request(self, required, optional)

      response = @service.perform_request(required, optional)
    end

    def query(repository_id, statement, succinct=false, optional = {})
      req = {succinct: succinct,
                  cmisselector: 'query',
                  repositoryId: repository_id,
                  q: statement}
      opt = {searchAllVersions: optional[:search_all_versions],
                  includeRelationships: optional[:include_relationships],
                  renditionFilter: optional[:rendition_filter],
                  includeAllowableActions: optional[:include_allowable_actions],
                  maxItems: optional[:max_items],
                  skipCount: optional[:skip_count]}
      perform_request(req, opt)
    end

    private
      def duplicate_object(object)
        if(object.is_a?(Array))
          array = []
          object.each do |element|
            array<<duplicate_object(element)
          end
          array
        elsif(object.is_a?(Hash))
          hash = {}
          object.each do |key, value|
            hash[key] = duplicate_object(value)
          end
          hash
        elsif(object == nil or object.is_a?(Fixnum) or object.is_a?(FalseClass) or object.is_a?(TrueClass) or object.is_a?(Symbol))
          object
        else
          begin
            object.dup
          rescue
            object
          end
        end
      end
  end

end

require 'yaccl/properties_helper'
require 'yaccl/model'
require 'yaccl/services'
require 'yaccl/validator'