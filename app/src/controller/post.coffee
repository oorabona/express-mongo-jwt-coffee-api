BaseController = require(APP_CONTROLLER_PATH + 'base')
PostHandler = require(APP_HANDLER_PATH + 'post')

class PostController extends BaseController
  constructor: ->
    super()
    @_postHandler = new PostHandler()
    @_passport = require 'passport'

  getAll: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      @_postHandler.getAllPosts req, @_responseManager.getDefaultResponseHandler res

  get: (req, res, next) ->
    responseManager = @_responseManager
    @authenticate req, res, next, (token, user) =>
      @_postHandler.getSinglePost req, responseManager.getDefaultResponseHandlerError res, (data, message, code) =>
        hateosLinks = [responseManager.generateHATEOASLink(req.baseUrl, "GET", "collection")]
        responseManager.respondWithSuccess(res, code || responseManager.HTTP_STATUS.OK, data, message, hateosLinks)

  create: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      @_postHandler.createNewPost req, @_responseManager.getDefaultResponseHandler res

  update: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      @_postHandler.updatePost req, @_responseManager.getDefaultResponseHandler res

  remove: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      @_postHandler.deletePost req, @_responseManager.getDefaultResponseHandler res

  authenticate: (req, res, next, callback) ->
    responseManager = @_responseManager
    @_passport.authenticate('jwt-rs-auth', {
      onVerified: callback
      onFailure: (error) ->
        responseManager.respondWithError res, error.status || 401, error.message
    })(req, res, next)

module.exports = PostController
