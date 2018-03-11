BaseController = require(APP_CONTROLLER_PATH + 'base')
UserHandler = require(APP_HANDLER_PATH + 'user')

class UserController extends BaseController
  constructor: ->
    super()
    @_authHandler = new UserHandler()
    @_passport = require 'passport'

  get: (req, res, next) ->
    responseManager = @_responseManager
    @_passport.authenticate('jwt-rs-auth', {
      onVerified: (token, user) =>
        @_authHandler.getUserInfo req, user, responseManager.getDefaultResponseHandler res
      onFailure: (error) =>
        responseManager.respondWithError res, error.status || 401, error.message
    })(req, res, next)

  create: (req, res) ->
    responseManager = @_responseManager
    @authenticate req, res, () =>
      @_authHandler.createNewUser req, responseManager.getDefaultResponseHandlerData res

  authenticate: (req, res, callback) ->
    responseManager = @_responseManager
    @_passport.authenticate('secret-key-auth', {
      onVerified: callback
      onFailure: (error) ->
        responseManager.respondWithError res, error.status || 401, error.message
    })(req, res, callback)

module.exports = UserController
