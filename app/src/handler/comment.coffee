{BlogCommentModel} = require(APP_MODEL_PATH + 'comment')
ValidationError = require(APP_ERROR_PATH + 'validation')
NotFoundError = require(APP_ERROR_PATH + 'not-found')
BaseAutoBindedClass = require(APP_BASE_PACKAGE_PATH + 'base-autobind')

class BlogCommentHandler extends BaseAutoBindedClass
  constructor: ->
    super()
    @_validator = require 'validator'
    @_customValidation = require './rules/comment'

  createNewComment: (req, callback) ->
    data = req.body
    validator = @_validator
    req.checkBody BlogCommentHandler.BLOG_COMMENT_VALIDATION_SCHEME()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new BlogCommentModel {
        title: validator.trim data.title
        content: validator.trim data.content
        tags: data.tags
        authorId: data.authorId
        postId: data.postId
      }
    .then @_customValidation.createNewComment
    .then (comment) =>
      comment.save()
      comment
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  deleteComment: (req, callback) ->
    data = req.body
    req.checkParams('cid', 'Invalid comment cid provided').isMongoId()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogCommentModel.findOne {_id: req.params.cid, postId: req.params.id}, (err, comment) ->
          if err isnt null
            reject err
          else
            if comment
              resolve comment
            else
              reject new NotFoundError "Comment not found"
    .then @_customValidation.deleteComment
    .then (comment) =>
      comment.remove()
      comment
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  updateComment: (req, callback) ->
    data = req.body
    validator = @_validator
    req.checkBody BlogCommentHandler.BLOG_COMMENT_VALIDATION_SCHEME false
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogCommentModel.findOne {_id: req.params.cid, postId: req.params.id}, (err, comment) ->
          if err isnt null
            reject err
          else
            if !comment
              reject new NotFoundError "Comment not found"
            else
              resolve comment
    .then @_customValidation.updateComment
    .then (comment) =>
      if 'string' is typeof data.content
        comment.content = validator.trim data.content
      if 'string' is typeof data.title
        comment.title = validator.trim data.title
      if Array.isArray data.tags
        comment.tags = data.tags
      comment.save()
      comment
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  getSingleComment: (req, callback) ->
    data = req.body
    req.checkParams('id', 'Invalid post id provided').isMongoId()
    req.checkParams('cid', 'Invalid comment id provided').isMongoId()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogCommentModel.findOne {_id: req.params.cid, postId: req.params.id}, (err, comment) ->
          if err isnt null
            reject err
          else
            if comment
              resolve comment
            else
              reject new NotFoundError "Comment not found"
    .then (comment) =>
      callback.onSuccess comment
    .catch (error) =>
      callback.onError error

  getAllComments: (req, callback) ->
    data = req.body
    req.checkParams('id', 'Invalid post id provided').isMongoId()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogCommentModel.find {postId: req.params.id}, (err, comments) ->
          if err isnt null
            reject err
          else
            resolve comments
    .then (comments) =>
      callback.onSuccess comments
    .catch (error) =>
      callback.onError error

  @BLOG_COMMENT_VALIDATION_SCHEME: (enforce = true) ->
    {
      'title':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 2, max: 150]
          errorMessage: 'Comment title must be between 2 and 150 chars long'
        errorMessage: "Invalid comment 'title'"
      'content':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 10, max: 3000]
          errorMessage: 'Comment content must be between 10 and 3000 chars long'
        errorMessage: "Invalid comment 'content'"
      'tags.*':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 2, max: 50]
          errorMessage: "Post tags must be between 2 and 50 chars long"
        errorMessage: "Invalid post 'tags' array"
      'postId':
        isMongoId:
          errorMessage: 'Not a valid id'
        errorMessage: 'Invalid postId provided'
      'authorId':
        isMongoId:
          errorMessage: 'Not a valid id'
        errorMessage: "Invalid authorId provided"
    }

module.exports = BlogCommentHandler
