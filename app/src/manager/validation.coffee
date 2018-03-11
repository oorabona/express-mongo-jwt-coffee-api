BaseAutoBindedClass = require APP_BASE_PACKAGE_PATH + 'base-autobind'
expressValidator = require 'express-validator'

class ValidationManager extends BaseAutoBindedClass
  constructor: ->
    super()

  provideDefaultValidator: ->
    expressValidator {
      errorFormatter: ValidationManager.errorFormatter
    }

  getErrorData: (errorArray) ->
    errorObject = {}
    errorArray.forEach (elem, index) ->
      if 'undefined' is typeof errorObject[elem.param]
        errorObject[elem.param] = elem.msg + ':'
      else
        errorObject[elem.param] += " #{elem.msg},"

    # Make sure it is properly displayed by removing last character ':' or ','
    # which definitely would make no sense to be kept.
    for param, msg of errorObject
      errorObject[param] = msg[...-1]

    errorObject

  errorFormatter: (param, msg, value) ->
    namespace = param.split('.')
    root = namespace.shift()
    formParam = root

    while namespace.length
      formParam += '[' + namespace.shift() + ']'

    {
      param: formParam
      msg: msg
      value: value
    }

module.exports = ValidationManager
