yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'

module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'name',
      type: String
      required: true
    return
  firstThing: ->
    cb = @async()
    console.log 'I\'m doin it'
    cb() 