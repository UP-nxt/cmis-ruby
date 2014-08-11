module CMIS
  module Exceptions
    InvalidArgument         = Class.new(StandardError)
    NotSupported            = Class.new(StandardError)
    ObjectNotFound          = Class.new(StandardError)
    PermissionDenied        = Class.new(StandardError)
    Runtime                 = Class.new(StandardError)
    Constraint              = Class.new(StandardError)
    ContentAlreadyExists    = Class.new(StandardError)
    FilterNotValid          = Class.new(StandardError)
    NameConstraintViolation = Class.new(StandardError)
    Storage                 = Class.new(StandardError)
    StreamNotSupported      = Class.new(StandardError)
    UpdateConflict          = Class.new(StandardError)
    Versioning              = Class.new(StandardError)

    # Non-CMIS
    Unauthorized            = Class.new(StandardError)
  end
end
