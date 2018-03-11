router = require('express').Router()
AuthController = require(APP_CONTROLLER_PATH + 'auth')
authController = new AuthController

router.post '/', authController.create
router.delete '/:token', authController.remove

module.exports = router
