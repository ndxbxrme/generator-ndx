yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
genUtils = require '../util'
_ = require 'underscore.string'
 
module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'dir',
      type: String
      required: false
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
    if not @dir
      @prompt [
        {
          name: 'dir'
          message: 'Where would you like to create this directive?'
          default: '/src/client/directives/menu'
        }
      ], ((answers) ->
        @filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '')
        cb()
        return
      ).bind(this)
    else
      cb()
    return
  write: ->
    @filters.dir = @filters.dir or @dir
    @sourceRoot path.join(__dirname, './templates/')
    @filters.templateDir = @filters.dir.replace('src/client/', '')
    @destinationRoot path.join(process.cwd(), @filters.dir)
    genUtils.write this, @filters
    return