ValidationError = require(APP_ERROR_PATH + 'validation')
{ BlogPostModel } = require(APP_MODEL_PATH + 'post')
{ editTagName, maxCommentDeleteExpInMS } = global.config.app

module.exports =
  createNewComment: (comment) -> comment
  deleteComment: (comment) ->
    return new Promise (resolve, reject) ->
      BlogPostModel.findOne {_id: comment.postId}, (err, post) ->
        if err isnt null
          reject err
        else
          ms = Math.abs post.dateCreated - Date.now()
          if ms < maxCommentDeleteExpInMS
            resolve post
        reject new ValidationError "Post was posted too long ago: #{ms} (greater than: #{maxCommentDeleteExpInMS})"
  updateComment: (comment) ->
    if editTagName in post.tags
      post
    else
      throw new ValidationError "Unauthorized update because tag '#{editTagName}' is not there."
