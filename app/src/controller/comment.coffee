BaseController = require(APP_CONTROLLER_PATH + 'base')
CommentHandler = require(APP_HANDLER_PATH + 'comment')

class CommentController extends BaseController
  constructor: ->
    super()
    @_commentHandler = new CommentHandler()
    @_passport = require 'passport'

  getAll: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      @_commentHandler.getAllComments req, @_responseManager.getDefaultResponseHandler res

  get: (req, res, next) ->
    responseManager = @_responseManager
    @authenticate req, res, next, (token, user) =>
      @_commentHandler.getSingleComment req, responseManager.getDefaultResponseHandlerError res, (data, message, code) =>
        hateosLinks = [responseManager.generateHATEOASLink(req.baseUrl, "GET", "collection")]
        responseManager.respondWithSuccess(res, code || responseManager.HTTP_STATUS.OK, data, message, hateosLinks)

  create: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      req.body.postId = req.params.id
      @_commentHandler.createNewComment req, @_responseManager.getDefaultResponseHandler res

  update: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      req.body.postId = req.params.id
      @_commentHandler.updateComment req, @_responseManager.getDefaultResponseHandler res

  remove: (req, res, next) ->
    @authenticate req, res, next, (token, user) =>
      req.body.authorId = user.id
      req.body.postId = req.params.id
      @_commentHandler.deleteComment req, @_responseManager.getDefaultResponseHandler res

  authenticate: (req, res, next, callback) ->
    responseManager = @_responseManager
    @_passport.authenticate('jwt-rs-auth', {
      onVerified: callback
      onFailure: (error) ->
        responseManager.respondWithError res, error.status || 401, error.message
    })(req, res, next)

module.exports = CommentController
