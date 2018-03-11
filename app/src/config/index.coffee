module.exports =
  app: require './app'
  auth: require './auth'
  db: require './db'
  server: require './server'
  jwtOptions: require './jwt-options'
  secrets: require('./secrets')(global.APP_SECRETS)
