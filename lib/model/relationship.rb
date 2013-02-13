require_relative 'object'
require_relative 'services'

module Model
  class Relationship < Object
    def self.create(raw)
      Relationship.new(raw)
    end

    def initialize(raw)
      super(raw)
      @source_id = raw['cmis:sourceId']
      @target_id = raw['cmis:targetId']
    end

    attr_reader :source_id
    attr_reader :target_id

    def source
      Object.create(Services.object.get_object(repository_id, source_id, nil, false, false, nil, false, false))
    end

    def target
      Object.create(Services.object.get_object(repository_id, target_id, nil, false, false, nil, false, false))
    end

  end
end