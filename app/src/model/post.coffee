mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId
BlogPostSchema = new Schema(
  title: String
  content: String
  tags: [String]
  authorId:
    type: ObjectId
    required: true
  dateCreated:
    type: Date
    default: Date.now
  dateModified:
    type: Date
    default: Date.now)

BlogPostSchema.pre 'update', (next, done) ->
  @dateModified = Date.now()
  next()
  return
BlogPostSchema.pre 'save', (next, done) ->
  @dateModified = Date.now()
  next()
  return

BlogPostSchema.methods.toJSON = ->
  obj = @toObject()
  delete obj.__v
  obj

module.exports.BlogPostModel = mongoose.model 'Post', BlogPostSchema
