mongoose = require 'mongoose'
Schema = mongoose.Schema

SubmissionSchema = new Schema
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
  user:
    type: String
    required: true
  status:
    type: String
    default: 'PENDING'
    enum: ['PENDING', 'AUTHORIZED', 'REJECTED', 'PAID']
  amount:
    type: Number
    min: 1
    required: true
  description:
    type: String
    default: ''
  picLink:
    type: String
    default: null
  paid:
    type: Boolean
    default: false
  receipt:
    type: String
    default: null
  authorizers:
    type: [String]
    default: []


mongoose.model 'Submission', SubmissionSchema