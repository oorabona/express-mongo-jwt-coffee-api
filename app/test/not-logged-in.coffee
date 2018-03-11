process.env.NODE_ENV = 'test'

chai = require 'chai'
chai.use require 'chai-http'
should = chai.should()

server = require '../lib'
{auth, post, user} = require './dataset'

describe 'When not connected,', ->
  describe 'the route /v1/auth', ->
    it 'should respond to GET with 404', ->
      chai.request server
      .get '/v1/auth'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 404
    it "should respond to empty POST and no authorization with code 400 and 'User not found'", ->
      chai.request server
      .post '/v1/auth'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'User not found'
    it "should respond to non-empty POST and no authorization with code 404 and 'User not found'", ->
      chai.request server
      .post '/v1/auth'
      .send auth.valid
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 404
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'User not found'
    it "should respond to empty POST and bad authorization with code 400 and 'User not found'", ->
      chai.request server
      .post '/v1/auth'
      .set 'Authorization', 'JWT xxx'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'User not found'
    it "should respond to non-empty POST and bad authorization with code 404 and 'User not found'", ->
      chai.request server
      .post '/v1/auth'
      .set 'Authorization', 'JWT xxx'
      .send auth
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'User not found'
    it 'should respond to PUT with code 404', ->
      chai.request server
      .put '/v1/auth'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 404

  describe 'the route /v1/posts', ->
    it "should respond to GET and no authorization with code 401 and 'No auth token provided'", ->
      chai.request server
      .get '/v1/posts'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'No auth token provided'
    it "should respond to GET and bad authorization with code 401 and 'jwt malformed'", ->
      chai.request server
      .get '/v1/posts'
      .set 'Authorization', 'JWT xxx'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'jwt malformed'
    it "should respond to POST, empty body and no authorization with code 401 and 'No auth token provided'", ->
      chai.request server
      .post '/v1/posts'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'No auth token provided'
    it "should respond to POST, empty body and bad authorization with code 401 and 'jwt malformed'", ->
      chai.request server
      .post '/v1/posts'
      .set 'Authorization', 'JWT xxx'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'jwt malformed'
    it "should respond to POST, with body and no authorization with code 401 and 'No auth token provided'", ->
      chai.request server
      .post '/v1/posts'
      .send post.without.tag
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'No auth token provided'
    it "should respond to POST, with body and bad authorization with code 401 and 'jwt malformed'", ->
      chai.request server
      .post '/v1/posts'
      .set 'Authorization', 'JWT xxx'
      .send post.without.tag
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'jwt malformed'

  describe 'the route /v1/users', ->
    it "should respond to GET with code 404", ->
      chai.request server
      .get '/v1/users'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 404
    it "should respond to GET :id with code 401 and 'No auth token provided'", ->
      chai.request server
      .get '/v1/users/1'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'No auth token provided'
    it "should respond to GET :id and bad authorization with code 401 and 'jwt malformed'", ->
      chai.request server
      .get '/v1/users/1'
      .set 'Authorization', 'JWT xxx'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 401
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'jwt malformed'
    it "should respond to POST, empty body and no authorization with code 400, 'There are validation errors' and detailed answer", ->
      chai.request server
      .post '/v1/users'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'There are validation errors'
        res.body.should.have.property 'data'
        res.body.data.should.eql
          firstName: 'Invalid first name: Firstname must be between 2 and 15 chars long'
          lastName: 'Invalid last name: Lastname must be between 2 and 15 chars long'
          email: 'Email does not respect conventions'
          password: 'Invalid password: Password must be between 6 and 35 chars long'
    it "should respond to POST, empty body and bad authorization with code 400, 'There are validation errors' and detailed answer", ->
      chai.request server
      .post '/v1/users'
      .set 'Authorization', 'JWT xxx'
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'There are validation errors'
        res.body.should.have.property 'data'
        res.body.data.should.eql
          firstName: 'Invalid first name: Firstname must be between 2 and 15 chars long'
          lastName: 'Invalid last name: Lastname must be between 2 and 15 chars long'
          email: 'Email does not respect conventions'
          password: 'Invalid password: Password must be between 6 and 35 chars long'
    it "should respond to POST, with empty property and no authorization with code 400, 'There are validation errors' and detailed answer", ->
      chai.request server
      .post '/v1/users'
      .send user.empty.property
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'There are validation errors'
        res.body.should.have.property 'data'
        res.body.data.should.eql
          firstName: 'Invalid first name: Firstname must be between 2 and 15 chars long'
    it "should respond to POST, with empty property and bad authorization with code 400, 'There are validation errors' and detailed answer", ->
      chai.request server
      .post '/v1/users'
      .set 'Authorization', 'JWT xxx'
      .send user.empty.property
      .catch (err) -> err.response
      .then (res) ->
        res.should.have.status 400
        res.body.should.be.a 'object'
        res.body.should.have.property 'success'
        res.body.success.should.be.false
        res.body.should.have.property 'message'
        res.body.message.should.equal 'There are validation errors'
        res.body.should.have.property 'data'
        res.body.data.should.eql
          firstName: 'Invalid first name: Firstname must be between 2 and 15 chars long'
