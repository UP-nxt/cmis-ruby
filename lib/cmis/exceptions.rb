module CMIS
  module Exceptions
    class InvalidArgument         < Exception; end
    class NotSupported            < Exception; end
    class ObjectNotFound          < Exception; end
    class PermissionDenied        < Exception; end
    class Runtime                 < Exception; end
    class Constraint              < Exception; end
    class ContentAlreadyExists    < Exception; end
    class FilterNotValid          < Exception; end
    class NameConstraintViolation < Exception; end
    class Storage                 < Exception; end
    class StreamNotSupported      < Exception; end
    class UpdateConflict          < Exception; end
    class Versioning              < Exception; end
  end
end
