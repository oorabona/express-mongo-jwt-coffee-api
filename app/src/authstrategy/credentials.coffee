LocalAuthStrategy = require('passport-local').Strategy
{UserModel} = require(APP_MODEL_PATH + 'user')
UnauthorizedError = require(APP_ERROR_PATH + 'unauthorized')
NotFoundError = require(APP_ERROR_PATH + 'not-found')

class CredentialsAuthStrategy extends LocalAuthStrategy
  constructor: ->
    super CredentialsAuthStrategy.provideOptions(), CredentialsAuthStrategy.handleUserAuth
    @name = 'credentials-auth'

  @handleUserAuth: (username, password, done) ->
    UserModel.findOne {email: username}, (err, user) ->
      return done(err) if err
      unless user
        return done new NotFoundError("User not found"), false
      if !user.checkPassword password
        return done new UnauthorizedError("Invalid credentials"), false
      return done null, user

  @provideOptions: ->
    {
      usernameField: 'email'
      passReqToCallback: false
      passwordField: 'password'
      session: false
    }

  getSecretKey: ->
    throw new Error "No key is required for this type of auth"

exports = module.exports = CredentialsAuthStrategy
