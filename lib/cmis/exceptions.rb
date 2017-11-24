module CMIS
  module Exceptions
    ServiceError                           = Class.new(StandardError)

    Constraint                             = Class.new(ServiceError)
    ContentAlreadyExists                   = Class.new(ServiceError)
    FilterNotValid                         = Class.new(ServiceError)
    InvalidArgument                        = Class.new(ServiceError)
    NameConstraintViolation                = Class.new(ServiceError)
    NotSupported                           = Class.new(ServiceError)
    ObjectNotFound                         = Class.new(ServiceError)
    PermissionDenied                       = Class.new(ServiceError)
    Runtime                                = Class.new(ServiceError)
    Storage                                = Class.new(ServiceError)
    StreamNotSupported                     = Class.new(ServiceError)
    UpdateConflict                         = Class.new(ServiceError)
    Versioning                             = Class.new(ServiceError)

    # Non-CMIS
    Unauthorized                           = Class.new(StandardError)
    Timeout                                = Class.new(StandardError)
  end
end
