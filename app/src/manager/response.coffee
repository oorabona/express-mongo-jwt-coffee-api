HttpStatus = require('http-status-codes')
BasicResponse =
  'success': false
  'message': ''
  'data': {}

class ResponseManager
  constructor: ->

  @HTTP_STATUS: HttpStatus

  @getDefaultResponseHandler: (res) ->
    return {
      onSuccess: (data, message, code) ->
        ResponseManager.respondWithSuccess res, code || ResponseManager.HTTP_STATUS.OK, data, message
      onError: (error) ->
        ResponseManager.respondWithError res, error.status || 500, error.message || 'Unknown error'
    }

  @getDefaultResponseHandlerData: (res) ->
    return {
      onSuccess: (data, message, code) ->
          ResponseManager.respondWithSuccess res, code || ResponseManager.HTTP_STATUS.OK, data, message
      onError: (error) ->
          ResponseManager.respondWithErrorData res, error.status, error.message, error.data
    }

  @getDefaultResponseHandlerError: (res, successCallback) ->
    return {
      onSuccess: (data, message, code) ->
        successCallback data, message, code
      onError: (error) ->
        ResponseManager.respondWithError res, error.status || 500, error.message || 'Unknown error'
    }

  @getDefaultResponseHandlerSuccess: (res, errorCallback) ->
    return {
      onSuccess: (data, message, code) ->
        ResponseManager.respondWithSuccess res, code || ResponseManager.HTTP_STATUS.OK, data, message
      onError: (error) ->
        errorCallback error
    }

  @generateHATEOASLink: (link, method, rel) ->
    return {
      link: link
      method: method
      rel: rel
    }

  @respondWithSuccess: (res, code, data, message = "", links = []) ->
    response = Object.assign {}, BasicResponse
    response.success = true
    response.message = message
    response.data = data
    response.links = links
    res.status(code).json response

  @respondWithErrorData: (res, errorCode, message = "", data = "", links = []) ->
    response = Object.assign {}, BasicResponse
    response.success = false
    response.message = message
    response.data = data
    response.links = links
    res.status(errorCode).json response

  @respondWithError: (res, errorCode, message = "", links = []) ->
    response = Object.assign {}, BasicResponse
    response.success = false
    response.message = message
    response.links = links
    res.status(errorCode).json response

module.exports = ResponseManager
