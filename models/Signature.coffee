mongoose = require 'mongoose'
Schema = mongoose.Schema

SignatureSchema = new Schema
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
  user:
    type: String
    required: true
  submission:
    type: Schema.Types.ObjectId
    required: true


mongoose.model 'Signature', SignatureSchema
