module.exports =
  editTagName: process.env.EDIT_TAGNAME || 'edit'
  # Default to 2h
  maxPostDeleteExpInMS: process.env.POST_EXP_IN_MS || 2*60*60*1000
  # Default to 23h42
  maxCommentDeleteExpInMS: process.env.COMMENT_EXP_IN_MS || (23*60+42)*60*1000
