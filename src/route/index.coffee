yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
genUtils = require '../util'
_ = require 'underscore.string'
 
module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'compname',
      type: String
      required: true
  checkForConfig: ->
    cb = @async()
    if @config.get 'filters'
      @filters = @config.get 'filters'
      @filters.compname = @compname
      @filters.compnameSlugged = _.slugify _.humanize(@compname)
      @filters.compnameCamel = _.camelize @filters.compnameSlugged
      @filters.compnameCapped = _.capitalize(@filters.compnameCamel).replace '-', ''
      @compname = _.slugify _.humanize(@compname)
      @filters.compname = @compname
    else
      @log 'Cannot find the config file'
      return
    cb()
  askFor: ->
    cb = @async()
    @prompt [
      {
        name: 'dir' 
        message: 'Where would you like to create this route?'
        default: "/src/client/routes/#{@filters.compname}"
      }
      {
        name: 'roles'
        message: 'User roles'
        default: ''
      }
      {
        name: 'parameters'
        message: 'Parameters, eg :id/something/:another'
        default: ''
      }
    ], ((answers) ->
      @filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '')
      @filters.roles = answers.roles
      @filters.parameters = answers.parameters
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