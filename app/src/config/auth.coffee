JwtRsStrategy = require(APP_AUTH_STRATEGY + 'jwt-rs')
SecretKeyAuth = require(APP_AUTH_STRATEGY + 'secret-key')
CredentialsAuth = require(APP_AUTH_STRATEGY + 'credentials')

module.exports =
  setupStrategies: ->
    # Setup authentication (JWT) strategy
    jwtOptions = @_provideJwtOptions()
    [
      new JwtRsStrategy jwtOptions, @_verifyRevokedToken
      new CredentialsAuth()
      new SecretKeyAuth secretKey: @_provideSecretKey()
    ]
