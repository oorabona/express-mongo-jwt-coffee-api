mongoose = require 'mongoose'
Schema = mongoose.Schema

RevokedTokenScheme = new Schema(
  token: String
  date:
    type: Date
    default: Date.now)

module.exports.RevokedTokenModel = mongoose.model 'RevokedToken', RevokedTokenScheme
