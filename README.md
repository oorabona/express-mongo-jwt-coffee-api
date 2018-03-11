# ExpressJS - MongoDB - JWT API

This is small project I had to develop as an example.
The idea was to develop a Web Application similar to a *blog*.

As I mostly develop using the `Meteor` framework, I wanted for this project to be (re-)usable as a boilerplate for `ExpressJS` projects. I read a really nice tutorial you can find [here](https://crosp.net/blog/web/nodejs/secure-rest-api-using-nodejs-part-2-express-jwt-mongoose) with its source on this [GitHub repo](https://github.com/CROSP/blog-api-nodejs-example) both were great inspiration as you can see. So kudos go to @CROSP !

## Exercise

So let's get to the point of this exercise. And what is expected to be able to achieve.

### Back

Develop a **REST API**, that will allow a user to login. Once logged in the user will be able to:
  - Read a post
  - Write a post
  - Edit his own posts **only** if the user add a tag `#EDIT`
  - Delete a post **only** when conditions are met **(1)**
  - Write comments on posts
  - Edit his own comments **only** if the user add a tag `#EDIT`
  - Delete his own comments **only** when conditions are met **(2)**

> **(1)** In this example the trigger is "if the post has no answer and has been posted in the past __2__ hours"

> **(2)** In this example the trigger is "if the post has been posted in the past __23 hours 42 minutes__"

> Of course, timeouts values were just part of the exercise and the proof of concept was to find a proper way to add your own rules with the assurance of good code maintenability while keeping everything proper.

### Front

No front end developped, not the point as its pure API :smile:

## Technologies

* **For the API**:
  - NodeJS (tested with v6+)
  - ExpressJS
  - MongoDB with Mongoose
  - JWT (JSON Web Token)

* **For the tests**:
  - Mocha
  - Chai

* **For all**:
  - CoffeeScript
  - Docker

## Caveats

I committed private keys as this is supposed to be an example, **not production ready code** !

It is up to you to clear them if you want and use this code as your base for your own piece of software ! :rocket:

As the `Dockerfile` stipulates, every time the container is built a new set of public/private key pairs are generated. :wink:

## How to run

```
# To run the test suite
$ docker-compose up test

# To run the application itself
$ docker-compose up staging
```

## TODO

Well, complete testing, and maybe enhance some parts !
Then, so many things can be done, like front end, additional features, and why not write a blog article based on that piece of software :laughing:

## Feedback

Feel free to use this code sample as a base of your ExpressJS applications, comments, issues, and pull requests are most welcome ! :beer:
