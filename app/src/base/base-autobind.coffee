autoBind = require 'auto-bind'

class BaseAutoBindedClass
  constructor: ->
    autoBind @

module.exports = BaseAutoBindedClass
