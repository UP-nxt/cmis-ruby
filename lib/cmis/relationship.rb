module CMIS
  class Relationship < Object
    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:sourceId cmis:targetId )
    end

    def source(opts = {})
      repository.object(source_id, opts)
    end

    def target(opts = {})
      repository.object(target_id, opts)
    end

    def create(opts = {})
      repository.create_relationship(self, opts)
    end
  end
end
