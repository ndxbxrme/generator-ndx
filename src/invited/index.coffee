yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
genUtils = require '../util'
_ = require 'underscore.string'
 
module.exports = yeoman.generators.Base.extend
  checkForConfig: ->
    cb = @async()
    @projectDir = process.cwd()
    if @config.get 'filters'
      @filters = @config.get 'filters'
    else
      @log 'Cannot find the config file'
      return
    cb()
  askFor: -> 
    cb = @async()
    @prompt [
      {
        name: 'dir'
        message: 'Where would you like to create this directive?'
        default: '/src/client/routes/invited'
      }
    ], ((answers) ->
      @filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '')
      cb()
      return
    ).bind(this)
    return
  write: ->
    @sourceRoot path.join(__dirname, './templates/')
    @filters.templateDir = @filters.dir.replace('src/client/', '')
    @destinationRoot path.join(process.cwd(), @filters.dir)
    genUtils.write this, @filters
    return