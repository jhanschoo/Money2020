mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema
  id:
    type: String
    required: true
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
  displayName:
    type: String
    default: ''
  submissions:
    type: [Schema.Types.ObjectId]
    default: []
  isAuthorizer:
    type: Boolean
    default: false
  accessKey:
    type: String
    required: true

mongoose.model 'User', UserSchema