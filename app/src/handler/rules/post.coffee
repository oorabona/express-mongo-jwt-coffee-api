ValidationError = require(APP_ERROR_PATH + 'validation')
{ BlogCommentModel } = require(APP_MODEL_PATH + 'comment')
{ editTagName, maxPostDeleteExpInMS } = global.config.app

module.exports =
  createNewPost: (post) -> post
  deletePost: (post) ->
    ms = Math.abs post.dateCreated - Date.now()
    if ms > maxPostDeleteExpInMS
      throw new ValidationError "Post was posted too long ago: #{ms} (greater than: #{maxPostDeleteExpInMS})"

    return new Promise (resolve, reject) ->
      BlogCommentModel.count {postId: post.id}, (err, commentsCount) ->
        if err isnt null
          reject err
        else if commentsCount is 0
          resolve post
        else
          reject new ValidationError "Unauthorized delete operation on post: #{commentsCount} comments exist!"
  updatePost: (post) ->
    if editTagName in post.tags
      post
    else
      throw new ValidationError "Unauthorized update because tag '#{editTagName}' is not there."
