class Type
    def self.create(raw)
        Type.new(raw)
    end

    def initialize(raw)
        @raw = raw
    end

    def to_hash
        raw
    end
end