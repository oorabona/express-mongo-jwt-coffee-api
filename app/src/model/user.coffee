mongoose = require 'mongoose'
crypto = require 'crypto'

Schema = mongoose.Schema
UserSchema = new Schema(
  firstName: String
  lastName: String
  salt:
    type: String
    required: true
  isActive:
    type: Boolean
    default: true
  dateCreated:
    type: Date
    default: Date.now
  email: String
  hashedPassword:
    type: String
    required: true)

UserSchema.methods.toJSON = ->
  obj = @toObject()
  delete obj.hashedPassword
  delete obj.__v
  delete obj.salt
  obj

UserSchema.virtual('id').get ->
  @_id
UserSchema.virtual('password').set((password) ->
  @salt = crypto.randomBytes(32).toString 'base64'
  @hashedPassword = @encryptPassword password, @salt
  return
).get ->
  @hashedPassword

UserSchema.methods.encryptPassword = (password, salt) ->
  crypto.createHmac('sha1', salt).update(password).digest 'hex'

UserSchema.methods.checkPassword = (password) ->
  @encryptPassword(password, @salt) == @hashedPassword

module.exports.UserModel = mongoose.model 'User', UserSchema
