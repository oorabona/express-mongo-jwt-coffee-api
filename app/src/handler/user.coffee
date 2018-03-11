{UserModel} = require(APP_MODEL_PATH + 'user')
AlreadyExistsError = require(APP_ERROR_PATH + 'already-exists')
ValidationError = require(APP_ERROR_PATH + 'validation')
UnauthorizedError = require(APP_ERROR_PATH + 'unauthorized')

class UserHandler
  constructor: ->
    @_validator = require 'validator'

  getUserInfo: (req, userToken, callback) ->
    req.checkParams('id', 'Invalid user id provided').isMongoId()
    req.getValidationResult()
    .then (result) =>
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      userId = req.params.id
      if userToken.id isnt req.params.id
        throw new UnauthorizedError "Provided id doesn't match with  the requested user id"
      else
        return new Promise (resolve, reject) ->
          UserModel.findById userId, (err, user) ->
            if user isnt null
              resolve user
    .then (user) =>
      callback.onSuccess user
    .catch (error) =>
      callback.onError error

  createNewUser: (req, callback) ->
    data = req.body
    validator = @_validator
    req.checkBody UserHandler.USER_VALIDATION_SCHEME
    req.getValidationResult()
    .then (result) =>
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new UserModel {
          firstName: validator.trim(data.firstName)
          lastName: validator.trim(data.lastName)
          email: validator.trim(data.email)
          password: validator.trim(data.password)
      }
    .then (user) =>
      return new Promise (resolve, reject) ->
        UserModel.find {email: user.email}, (err, docs) ->
          if docs.length
            reject new AlreadyExistsError "User already exists"
          else
            resolve user
    .then (user) =>
      user.save()
      user
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  @USER_VALIDATION_SCHEME:
    {
      'firstName':
        notEmpty: true
        isLength:
          options: [min: 2, max: 15]
          errorMessage: 'Firstname must be between 2 and 15 chars long'
        errorMessage: "Invalid first name"
      'lastName':
        notEmpty: true
        isLength:
          options: [min: 2, max: 15]
          errorMessage: 'Lastname must be between 2 and 15 chars long'
        errorMessage: "Invalid last name"
      'email':
        isEmail:
          errorMessage: "Email does not respect conventions"
        errorMessage: "Invalid email"
      'password':
        notEmpty: true
        isLength:
          options: [min: 6, max: 35]
          errorMessage: 'Password must be between 6 and 35 chars long'
        errorMessage: "Invalid password"
    }

module.exports = UserHandler
