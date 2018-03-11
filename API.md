# API

This document explains routes, expected input documents and responses from the API.

## How the API works

The API is meant to be as compliant to RESTful guidelines. As such `PUT` and `PATCH` behave differently: the former expects a full update of data whereas the latter accepts only partial update of the resource.

### Objects
Quick access to manipulated objects will give you all details.

- [Users](#users)
- [Auth](#auth)
- [Posts](#posts)
- [Comments](#comments)

## Users

### Routes

Object | Endpoint | Method | Description
-|-|-|-|
[User](app/src/model/user.coffee) | /v1/users/:id? | GET | Get all users or a specific one if `id` is provided
[User](app/src/model/user.coffee) | /v1/users/ | POST | Create a new user
[User](app/src/model/user.coffee) | /v1/users/:id | PUT | **TODO** Update all data of a given user (`id` is mandatory)
[User](app/src/model/user.coffee) | /v1/users/:id | PATCH | **TODO** Update part of user data (`id` is mandatory)

## Auth

### Routes

Object | Endpoint | Method | Description
-|-|-|-|
[Auth](app/src/model/auth/) | /v1/auth/ | POST | Create a new JWT token
[Auth](app/src/model/auth/) | /v1/auth/:id | DELETE | Revoke a JWT token (`id` is mandatory)

## Posts

### Routes

Object | Endpoint | Method | Description
-|-|-|-|
[Post](app/src/model/post.coffee) | /v1/posts/:id? | GET | Get all posts or a specific one if `id` is provided
[Post](app/src/model/post.coffee) | /v1/posts/ | POST | Create a new post
[Post](app/src/model/post.coffee) | /v1/posts/:id | PUT | Update all data of a given post (`id` is mandatory)
[Post](app/src/model/post.coffee) | /v1/posts/:id | DELETE | Delete a given post (`id` is mandatory)
[Post](app/src/model/post.coffee) | /v1/posts/:id | PATCH | **TODO** Update part of user data (`id` is mandatory)

## Comments

### Routes

Object | Endpoint | Method | Description
-|-|-|-|
[Comment](app/src/model/comment.coffee) | /v1/posts/:id/comments/:cid? | GET | Get all comments or a specific one if `cid` is provided (`id` is mandatory)
[Comment](app/src/model/comment.coffee) | /v1/posts/:id/comments/ | POST | Post a new comment (`id` is mandatory)
[Comment](app/src/model/comment.coffee) | /v1/posts/:id/comments/:cid | PUT | Update all data of a given comment (`id` and `cid` are mandatory)
[Comment](app/src/model/comment.coffee) | /v1/posts/:id/comments/:cid | DELETE | Delete a given comment on a post (`id` and `cid` are mandatory)
[Comment](app/src/model/comment.coffee) | /v1/posts/:id/comments/:cid | PATCH | **TODO** Update part of comments data (`id` and `cid` are mandatory)
