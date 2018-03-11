RevokedToken = require(APP_MODEL_PATH + 'auth/revoked-token').RevokedTokenModel
NotFoundError = require(APP_ERROR_PATH + 'invalid-payload')
BaseAutoBindedClass = require(APP_BASE_PACKAGE_PATH + 'base-autobind')
ForbiddenError = require(APP_ERROR_PATH + 'forbidden')

crypto = require 'crypto'
SHA_HASH_LENGTH = 64

class AuthHandler extends BaseAutoBindedClass
  constructor: ->
    super()
    @_jwtTokenHandler = require 'jsonwebtoken'
    @_authManager = require(APP_MANAGER_PATH + 'auth')
    @_authManager._setPassportStrategies global.config.auth.setupStrategies

  issueNewToken: (req, user, callback) ->
    if user
      userToken = @_authManager.signToken "jwt-rs-auth", @_provideTokenPayload(user), @_provideTokenOptions()
      callback.onSuccess userToken
    else
      callback.onError new NotFoundError "User not found"

  revokeToken: (req, token, callback) ->
    req.checkParams('token', 'Invalid token id provided').notEmpty().isAlphanumeric().isLength(SHA_HASH_LENGTH)
    req.getValidationResult()
    .then (result) =>
      unless result.isEmpty()
        errorMessages = result.array().map (elem) -> elem.msg
        throw new ForbiddenError('Invalid token id :' + errorMessages.join ' && ')

      tokenHashedId = req.params.token
      if @checkIfHashedTokenMatches token, tokenHashedId
        return new RevokedToken {token: token}
      else
        throw new ForbiddenError 'Invalid credentials'
    .then (token) =>
      token.save()
      token
    .then (token) =>
      callback.onSuccess "Token has been successfully revoked"
    .catch (error) =>
      callback.onError error

  _hashToken: (token) ->
    crypto.createHash('sha256').update(token).digest 'hex'

  checkIfHashedTokenMatches: (token, hashed) ->
    hashedValid = @_hashToken token
    hashedValid is hashed

  _provideTokenPayload: (user) ->
    {
      id: user.id
      scope: 'default'
    }

  _provideTokenOptions: ->
    {config} = global
    {
      expiresIn: "10 days"
      audience: config.jwtOptions.audience
      issuer: config.jwtOptions.issuer
      header: alg: config.jwtOptions.algorithm
    }

module.exports = AuthHandler
