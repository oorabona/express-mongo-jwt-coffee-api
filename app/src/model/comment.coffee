mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId
BlogCommentSchema = new Schema(
  title: String
  content: String
  tags: [String]
  postId:
    type: ObjectId
    required: true
  authorId:
    type: ObjectId
    required: true
  dateCreated:
    type: Date
    default: Date.now
  dateModified:
    type: Date
    default: Date.now)

BlogCommentSchema.pre 'update', (next, done) ->
  @dateModified = Date.now()
  next()
  return
BlogCommentSchema.pre 'save', (next, done) ->
  @dateModified = Date.now()
  next()
  return

BlogCommentSchema.methods.toJSON = ->
  obj = @toObject()
  delete obj.__v
  obj

module.exports.BlogCommentModel = mongoose.model 'Comment', BlogCommentSchema
