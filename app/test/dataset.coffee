auth =
  email: 'foo@bar.com'
  password: 'password'

authNotValid =
  email: 'foo@bar.xyz'
  password: 'password'

post =
  title: 'this is a title'
  content: 'this is a content'

postWithTag =
  title: 'this is a post with tag'
  content: 'this is a post content with tag'
  tags: ['tag']

postWithEditTag =
  title: 'this is a post with edit tag'
  content: 'this is a post content with edit tag'
  tags: ['edit']

user =
  firstName: "first_name"
  lastName: "last_name"
  email: "foo@bar.com"
  password: "password"

userEmptyProperty =
  firstName: ''
  lastName: "last_name"
  email: "foo@bar.com"
  password: "password"

module.exports =
  auth:
    valid: auth
    not:
      valid: authNotValid
  user:
    empty:
      property: userEmptyProperty
    valid: user
  post:
    without:
      tag: post
    with:
      tag: postWithTag
      edit: tag: postWithTag
