BaseError = require(APP_ERROR_PATH + 'base')

class ValidationError extends BaseError
  constructor: (message, data) ->
    super message, 400, data

module.exports = ValidationError
