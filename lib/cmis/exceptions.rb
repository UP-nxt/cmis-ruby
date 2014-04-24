module CMIS
  module Exceptions
    InvalidArgument         = Class.new(Exception)
    NotSupported            = Class.new(Exception)
    ObjectNotFound          = Class.new(Exception)
    PermissionDenied        = Class.new(Exception)
    Runtime                 = Class.new(Exception)
    Constraint              = Class.new(Exception)
    ContentAlreadyExists    = Class.new(Exception)
    FilterNotValid          = Class.new(Exception)
    NameConstraintViolation = Class.new(Exception)
    Storage                 = Class.new(Exception)
    StreamNotSupported      = Class.new(Exception)
    UpdateConflict          = Class.new(Exception)
    Versioning              = Class.new(Exception)

    # Non-CMIS
    Unauthorized            = Class.new(Exception)
  end
end
