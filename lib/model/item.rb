class Item < Object
    def self.create(raw)
        Item.new(raw)
    end

    def initialize(raw)
        super(raw)
    end

end