request = require 'request'
constants = require '../constants'

ACCESS_TOKEN = constants.ACCESS_TOKEN
URL = 'https://api.venmo.com/v1/payments'

this.make = (submission) ->
  if submission.status != 'AUTHORIZED' or not submission.user
    return

  console.log submission.amount
  console.log (submission.amount / 100)
  console.log (submission.amount / 100).toFixed(2)

  request.post(
      url: URL
      form:
        access_token: ACCESS_TOKEN
        phone: submission.user
        note: if submission.picLink then submission.description + ' ' + submission.picLink  else submission.description
        amount: (submission.amount / 100).toFixed(2)
        audience: 'private'
    , (err, httpResponse, body) ->
      bodyObj = JSON.parse body
      if bodyObj.error
        return
      submission.receipt = body
      submission.status = 'PAID'
      submission.save()
  )

module.exports = this