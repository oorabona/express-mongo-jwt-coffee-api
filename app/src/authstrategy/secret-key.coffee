BaseAuthStrategy = require(APP_AUTH_STRATEGY + 'base-auth')
InvalidPayloadError = require(APP_ERROR_PATH + 'invalid-payload')
UnauthorizedError = require(APP_ERROR_PATH + 'unauthorized')

class SecretKeyAuthStrategy extends BaseAuthStrategy
  @name: 'secret-key-auth'
  @AUTH_HEADER: "Authorization"

  constructor: (options) ->
    super()
    @_options = options
    @_initStrategy()

  _initStrategy: ->

  _verifyCredentials: (key) ->
    key is @provideSecretKey()

  authenticate: (req, callback) ->
    secretKey = SecretKeyAuthStrategy._extractKeyFromHeader req
    unless secretKey
      return callback.onFailure new InvalidPayloadError "No auth key provided"

    if @_verifyCredentials secretKey
      return callback.onVerified()
    else
      return callback.onFailure new UnauthorizedError "Invalid secret key"

  provideSecretKey: -> @_options.secretKey

  provideOptions: -> @_options

  _extractKeyFromHeader: (req) ->
    req.headers[SecretKeyAuthStrategy.AUTH_HEADER.toLowerCase()]

module.exports = SecretKeyAuthStrategy
