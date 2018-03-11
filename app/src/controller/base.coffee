ResponseManager = require(APP_MANAGER_PATH + 'response')
BaseAutoBindedClass = require(APP_BASE_PACKAGE_PATH + 'base-autobind')

class BaseController extends BaseAutoBindedClass
  constructor: ->
    super()
    # You can escape specific ES6 keywords in CoffeeScript using ``
    if `new.target` is BaseController
      throw new TypeError "Cannot construct BaseController instances directly"

    @_responseManager = ResponseManager

  getAll: (req, res) ->

  get: (req, res) ->

  create: (req, res) ->

  update: (req, res) ->

  remove: (req, res) ->

  authenticate: (req, res, callback) ->

module.exports = BaseController
