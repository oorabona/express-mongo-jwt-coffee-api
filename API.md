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

## User

### Routes

Object | Endpoint | Method | Description
-|
Users | /v1/users/:id? | GET | Get all users or a specific one if `id` is provided
Users | /v1/users/ | POST | Create a new user
Users | /v1/users/:id | PUT | Update all data of a given user (`id` is mandatory)
Users | /v1/users/:id | PATCH | Update part of user data (`id` is mandatory)

## Auth

### Routes

Object | Endpoint | Method | Description
-|
Users | /v1/users/:id? | GET | Get all users or a specific one if `id` is provided
Users | /v1/users/ | POST | Create a new user
Users | /v1/users/:id | PUT | Update all data of a given user (`id` is mandatory)
Users | /v1/users/:id | PATCH | Update part of user data (`id` is mandatory)

## Post

### Routes

Object | Endpoint | Method | Description
-|
Users | /v1/users/:id? | GET | Get all users or a specific one if `id` is provided
Users | /v1/users/ | POST | Create a new user
Users | /v1/users/:id | PUT | Update all data of a given user (`id` is mandatory)
Users | /v1/users/:id | PATCH | Update part of user data (`id` is mandatory)

## Comment

### Routes

Object | Endpoint | Method | Description
-|
Users | /v1/users/:id? | GET | Get all users or a specific one if `id` is provided
Users | /v1/users/ | POST | Create a new user
Users | /v1/users/:id | PUT | Update all data of a given user (`id` is mandatory)
Users | /v1/users/:id | PATCH | Update part of user data (`id` is mandatory)
