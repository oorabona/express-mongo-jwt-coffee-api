router = require('express').Router()
PostController = require(APP_CONTROLLER_PATH + 'post')
CommentController = require(APP_CONTROLLER_PATH + 'comment')

postController = new PostController
commentController = new CommentController

router.get '/', postController.getAll
router.get '/:id', postController.get
router.get '/:id/comments/', commentController.getAll
router.get '/:id/comments/:cid', commentController.get
router.post '/', postController.create
router.post '/:id/comments/', commentController.create
router.delete '/:id', postController.remove
router.delete '/:id/comments/:cid', commentController.remove
router.put '/:id', postController.update
router.put '/:id/comments/:cid', commentController.update

module.exports = router
