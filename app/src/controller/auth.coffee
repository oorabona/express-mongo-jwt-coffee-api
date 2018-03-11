BaseController = require(APP_CONTROLLER_PATH + 'base')
AuthHandler = require(APP_HANDLER_PATH + 'auth')

class AuthController extends BaseController
  constructor: ->
    super()
    @_authHandler = new AuthHandler()
    @_passport = require 'passport'

  # Request token by credentials
  create: (req, res, next) ->
    responseManager = @_responseManager
    @authenticate req, res, next, (user) =>
      @_authHandler.issueNewToken req, user, responseManager.getDefaultResponseHandler res

  # Revoke Token
  remove: (req, res, next) ->
    responseManager = @_responseManager
    @_passport.authenticate('jwt-rs-auth', {
      onVerified: (token, user) =>
        @_authHandler.revokeToken req, token, responseManager.getDefaultResponseHandler res
      onFailure: (error) ->
        responseManager.respondWithError res, error.status || 401, error.message
    })(req, res, next)

  authenticate: (req, res, next, callback) ->
    responseManager = @_responseManager
    @_passport.authenticate('credentials-auth', (err, user) ->
      if err
        responseManager.respondWithError(res, err.status || 401, err.message || "")
      else
        callback user
    )(req, res, next)

module.exports = AuthController
