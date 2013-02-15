require_relative 'object'

module UpnxtStorageLibCmisRuby
  module Model
    class Item < Object
      def initialize(repository_id, raw={})
        super(repository_id, raw)
      end
    end
  end
end
