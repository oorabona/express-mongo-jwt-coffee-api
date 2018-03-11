# Root path
global.APP_ROOT_PATH = __dirname + '/'

# Set other app paths
require './config/global-paths'

# Set config variables
global.config = require './config'

# Create an Express App
express = require 'express'
app = express()

# Include dependencies
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
routes = require APP_ROUTE_PATH

# Validation management is app wide with global scope
ValidationManager = require APP_MANAGER_PATH + 'validation'
global.validationManager = new ValidationManager

# Connect to DB
mongoose.Promise = global.Promise
mongoose.connect config.db.MONGO_CONNECT_URL

# Use json formatter middleware
app.use bodyParser.json()

# Set Up validation middleware
app.use validationManager.provideDefaultValidator()

# Setup routes
app.use '/', routes

if process.env.NODE_ENV is 'test'
  console.log 'App running in test mode: not listening.'
else
  app.listen global.config.server.PORT, ->
    console.log 'App is running on ' + global.config.server.PORT
    return

module.exports = app
