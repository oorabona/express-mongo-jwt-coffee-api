# You can add custom properties here.
# If not specified a standard error 500 is returned.
# You can also add custom data to have detailed information on what/where it originates.

class BaseError extends Error
  constructor: (message, @status = 500, @data) ->
    # Calling base class ctor
    super message

    # Capture stack trace excluding constructor call from it
    Error.captureStackTrace this, this.constructor

    # Saving class name in the property of our custom error as a shortcut.
    @name = @constructor.name

module.exports = BaseError
