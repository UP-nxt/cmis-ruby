require_relative 'object'

module Model
  class Item < Object
    def self.create(repository_id, raw)
      Item.new(repository_id, raw)
    end

    def initialize(repository_id, raw = {})
      super(repository_id, raw)
    end

  end
end