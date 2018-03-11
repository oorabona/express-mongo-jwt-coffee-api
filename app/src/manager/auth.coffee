{ ExtractJwt } = require 'passport-jwt'
BaseAutoBindedClass = require(APP_BASE_PACKAGE_PATH + 'base-autobind')
JwtToken = require(APP_MODEL_PATH + 'auth/jwt-token')
RevokedToken = require(APP_MODEL_PATH + 'auth/revoked-token').RevokedTokenModel
ForbiddenError = require(APP_ERROR_PATH + 'forbidden')

fs = require 'fs'

class AuthManager extends BaseAutoBindedClass
  constructor: ->
    super()
    @_passport = require 'passport'
    @_strategies = []
    @_jwtTokenHandler = require 'jsonwebtoken'

  extractJwtToken: (req) ->
    ExtractJwt.fromAuthHeader()(req)

  _verifyRevokedToken: (token, payload, callback) ->
    RevokedToken.find {token: token}, (err, docs) ->
      if docs.length
        callback.onFailure new ForbiddenError "Token has been revoked"
      else
        callback.onVerified token, payload

  _provideJwtOptions: ->
    {jwtOptions} = global.config
    jwtOptions.extractJwtToken = ExtractJwt.fromAuthHeader()
    jwtOptions.privateKey = @_provideJwtPrivateKey()
    jwtOptions.publicKey = @_provideJwtPublicKey()
    jwtOptions

  _provideJwtPublicKey: ->
    fs.readFileSync global.config.secrets.pubKey, 'utf8'

  _provideJwtPrivateKey: ->
    fs.readFileSync global.config.secrets.pemKey, 'utf8'

  _provideSecretKey: ->
    fs.readFileSync global.config.secrets.priKey, 'utf8'

  # To avoid hassle in cross referencing config/manager/handler, prefer the
  # callback design pattern with class instance scope. To maintain clarity
  # the function returns what should be modified in the class while allowing
  # the callback to 'read' from us...
  _setPassportStrategies: (setupStrategiesFn) ->
    @_strategies = setupStrategiesFn.call @
    passport = @_passport
    @_strategies.forEach (strategy) ->
      passport.use strategy

  providePassport: -> @_passport

  getSecretKeyForStrategy: (name) ->
    for strategy in @_strategies
      return strategy.provideSecretKey() if strategy.name is name

  signToken: (strategyName, payload, options) ->
    key = @getSecretKeyForStrategy strategyName
    switch strategyName
      when 'jwt-rs-auth'
        return new JwtToken(
          @_jwtTokenHandler.sign payload, key, options
        )
      else
        throw new TypeError "Cannot sign token for the #{strategyName} strategy"

exports = module.exports = new AuthManager()
