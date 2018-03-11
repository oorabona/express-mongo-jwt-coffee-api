router = require('express').Router()
UserController = require(APP_CONTROLLER_PATH + 'user')
userController = new UserController

router.get '/:id', userController.get
router.post '/', userController.create

module.exports = router
