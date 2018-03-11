passport = require 'passport-strategy'
jwt = require 'jsonwebtoken'

BaseAuthStrategy = require(APP_AUTH_STRATEGY + 'base-auth')

class JwtRsStrategy extends BaseAuthStrategy
  constructor: (options, verify) ->
    super()
    @_options = options
    @_customVerifier = verify
    @_initStrategy()
    @name = 'jwt-rs-auth'

  _initStrategy: ->
    passport.Strategy.call @
    options = @provideOptions()

    unless options
      throw new TypeError 'JwtRsStrategy requires options'

    @_privateKey = options.privateKey
    unless @_privateKey
      throw new TypeError 'JwtRsStrategy requires a private key'

    @_publicKey = options.publicKey
    unless @_publicKey
      throw new TypeError 'JwtRsStrategy requires a public key'

    @_extractJwtToken = options.extractJwtToken
    unless @_extractJwtToken
      throw new TypeError 'JwtRsStrategy requires a function to parse jwt from requests'

    @_verifyOpts = {}

    if options.issuer
      @_verifyOpts.issuer = options.issuer

    if options.audience
      @_verifyOpts.audience = options.audience

    if options.algorithms
      @_verifyOpts.algorithms = options.algorithms

    if options.ignoreExpiration != null
      @_verifyOpts.ignoreExpiration = options.ignoreExpiration

  provideSecretKey: -> @_privateKey

  authenticate: (req, callback) ->
    token = @_extractJwtToken req

    unless token
      return callback.onFailure new Error "No auth token provided"

    # Verify the JWT
    JwtRsStrategy._verifyDefault token, @_publicKey, @_verifyOpts, (jwt_err, payload) =>
      if jwt_err
        return callback.onFailure jwt_err
      else
        try
          # If custom verifier was set delegate the flow control
          if @_customVerifier
            @_customVerifier token, payload, callback
          else
            callback.onVerified token, payload
        catch ex
          callback.onFailure ex

  provideOptions: -> @_options

  @_verifyDefault: (token, publicKey, options, callback) ->
    jwt.verify token, publicKey, options, callback

module.exports = JwtRsStrategy
