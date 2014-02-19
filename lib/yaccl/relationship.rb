module YACCL
  class Relationship < Object

    def initialize(raw, repository)
      super
      cmis_properties %w( cmis:sourceId cmis:targetId )
    end

    def source
      repository.object(source_id)
    end

    def target
      repository.object(target_id)
    end

  end
end
