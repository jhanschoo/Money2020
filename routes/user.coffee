debug = require 'debug', 'expressapp'
express = require 'express'
mongoose = require 'mongoose'

router = express.Router()

User = mongoose.model 'User'

BASE_ACCESS_KEY = 'PC94Z5E3HpZdu8DzkmynDW6JMrkXtyrP'

# GET users listing.
router.get '/api/user/:id', (req, res) ->
  console.log req.params.id
  User.findOne
      id: req.params.id
    , null
    , (err, user) ->

      res.json user

router.post '/api/user/create', (req, res) ->
  if req.body.isAuthorizer == 'true'
    isAuthorizer = true
  else
    isAuthorizer = false

  user = new User
    id: req.body.id
    displayName: req.body.displayName
    isAuthorizer: isAuthorizer
    accessKey: req.body.accessKey

  user.save()
  res.json user

module.exports = router
