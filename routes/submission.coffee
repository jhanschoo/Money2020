_ = require 'lodash'
express = require 'express'
mongoose = require 'mongoose'
payment = require '../workers/payment.coffee'

router = express.Router()

User = mongoose.model 'User'
Signature = mongoose.model 'Signature'
Submission = mongoose.model 'Submission'

# GET users listing.
router.get '/api/user/:id/submission', (req, res) ->
  Submission.find
      user: req.params.id
    , null
    , (err, submissions) ->

      res.json submissions


router.get '/api/user/:id/submission/authorizable', (req, res) ->
  Submission.find
      authroizer: req.params.id
    , null
    , (err, submissions) ->

      res.json submissions


router.post '/api/user/:id/submission/create', (req, res) ->
  # get list of authorizers needed to approve submission
  User.find
      isAuthorizer: true
    , null
    , (err, authorizers) ->

      authorizerIds = _.pluck authorizers, 'id'

      submission = new Submission
        user: req.params.id
        status: 'PENDING'
        amount: req.body.amount
        description: req.body.description
        authorizers: authorizerIds

      submission.save()

      # get the user who created the submission
      User.findOne
          id: req.params.id
        , null
        , (err, user) ->
          user.submissions.push(submission._id)
          user.save (err, user) ->

            # this user automatically authorizes this submission if this user is an authorizer
            if user.isAuthorizer
              # TODO: authorize
              authorizeSubmission user.id, submission._id, null, null

            res.json submission


router.get '/api/submission/:id', (req, res) ->
  Submission.findOne
      _id: req.params.id
    , null
    , (err, submission) ->

      res.json submission


authorizeSubmission = (userId, submissionId, req, res) ->
  signature = new Signature
    user: userId
    submission: submissionId

  # find the submission that needs to be signed
  Submission.findOne
      _id: submissionId
    , null
    , (err, submission) ->

      # confirm that userId is a required authorizer
      console.log userId, submission.authorizers
      if userId not in submission.authorizers
        if res
          res.send userId + ' is not a required authorizer of submission ' + submissionId
      else
        signature.save (err, signature) ->
          # after authorizing, check if submission authorized ought to be processed
          Signature.find
              submission: submissionId
            , null
            , (err, signatures) ->
              authorizers = _.uniq (_.pluck signatures, 'user')
              console.log authorizers, submission.authorizers
              if authorizers.length >= submission.authorizers.length and submission.status == 'PENDING'
                submission.status = 'AUTHORIZED'
                submission.save (err, submission) ->
                  payment.make submission
              res.json signature


router.post '/api/submission/:id/authorize', (req, res) ->
  authorizeSubmission req.body.user, req.params.id, req, res

module.exports = router

