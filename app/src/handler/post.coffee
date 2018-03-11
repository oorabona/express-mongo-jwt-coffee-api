{BlogPostModel} = require(APP_MODEL_PATH + 'post')
ValidationError = require(APP_ERROR_PATH + 'validation')
NotFoundError = require(APP_ERROR_PATH + 'not-found')
UnauthorizedError = require(APP_ERROR_PATH + 'unauthorized')
BaseAutoBindedClass = require(APP_BASE_PACKAGE_PATH + 'base-autobind')

class BlogPostHandler extends BaseAutoBindedClass
  constructor: ->
    super()
    @_validator = require 'validator'
    @_customValidation = require './rules/post'

  createNewPost: (req, callback) ->
    data = req.body
    validator = @_validator
    req.checkBody BlogPostHandler.BLOG_POST_VALIDATION_SCHEME()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorMessages = []
        result.array().forEach (elem, index) ->
          if index % 2 is 0
            errorMessages.push "#{elem.msg}: "
          else
            errorMessages[errorMessages.length-1] += elem.msg

        throw new ValidationError 'There are validation errors: ' + errorMessages.join ' && '
      return new BlogPostModel {
        title: validator.trim(data.title)
        content: validator.trim(data.content)
        tags: data.tags
        authorId: data.authorId
      }
    .then @_customValidation.createNewPost
    .then (post) =>
      post.save()
      post
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  deletePost: (req, callback) ->
    data = req.body
    req.checkParams('id', 'Invalid post id provided').isMongoId()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogPostModel.findOne {_id: req.params.id, authorId: req.body.authorId}, (err, post) ->
          if err isnt null
            reject err
          else
            if post
              resolve post
            else
              reject new NotFoundError "Post not found"
    .then @_customValidation.deletePost
    .then (post) =>
      post.remove()
      post
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  updatePost: (req, callback) ->
    data = req.body
    validator = @_validator
    req.checkBody BlogPostHandler.BLOG_POST_VALIDATION_SCHEME false
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogPostModel.findOne {_id: req.params.id}, (err, post) ->
          if err isnt null
            reject err
          else
            if post
              # We must use toString representation of authorId which is a MongoDB object
              if post.authorId.toString() is req.body.authorId
                resolve post
              else
                reject new UnauthorizedError "Not authorized to update this post."
            else
              reject new NotFoundError "Post not found"
    .then @_customValidation.updatePost
    .then (post) =>
      if 'string' is typeof data.content
        post.content = validator.trim data.content
      if 'string' is typeof data.title
        post.title = validator.trim data.title
      if Array.isArray data.tags
        post.tags = data.tags
      post.save()
      post
    .then (saved) =>
      callback.onSuccess saved
    .catch (error) =>
      callback.onError error

  getSinglePost: (req, callback) ->
    data = req.body
    req.checkParams('id', 'Invalid post id provided').isMongoId()
    req.getValidationResult()
    .then (result) ->
      if !result.isEmpty()
        errorData = validationManager.getErrorData result.array()
        throw new ValidationError 'There are validation errors', errorData

      return new Promise (resolve, reject) ->
        BlogPostModel.findOne {_id: req.params.id}, (err, post) ->
          if err isnt null
            reject err
          else
            if post
              resolve post
            else
              reject new NotFoundError "Post not found"
    .then (post) =>
      callback.onSuccess post
    .catch (error) =>
      callback.onError error

  getAllPosts: (req, callback) ->
    data = req.body
    new Promise (resolve, reject) ->
      BlogPostModel.find {}, (err, posts) ->
        if err isnt null
          reject err
        else
          resolve posts
    .then (posts) =>
      callback.onSuccess posts
    .catch (error) =>
      callback.onError error

  @BLOG_POST_VALIDATION_SCHEME: (enforce = true) ->
    {
      'title':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 2, max: 150]
          errorMessage: 'Post title must be between 2 and 150 chars long'
        errorMessage: "Invalid post 'title'"
      'content':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 10, max: 3000]
          errorMessage: 'Post content must be between 10 and 3000 chars long'
        errorMessage: "Invalid post 'content'"
      'tags.*':
        notEmpty: enforce
        optional: !enforce
        isLength:
          options: [min: 2, max: 50]
          errorMessage: "Post tags must be between 2 and 50 chars long"
        errorMessage: "Invalid post 'tags' array"
      'authorId':
        isMongoId:
          errorMessage: 'Not a valid id'
        errorMessage: "Invalid AuthorId provided"
    }

module.exports = BlogPostHandler
