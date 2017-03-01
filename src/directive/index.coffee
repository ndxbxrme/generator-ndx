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
    @compname = _.slugify _.humanize(@compname)
  checkForConfig: ->
    cb = @async()
    if @config.get 'filters'
      @filters = @config.get 'filters'
      @filters.compname = @compname
      @filters.compnameCamel = _.camelize @compname
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
        default: '/src/client/directives'
      }
      {
        type: 'confirm'
        name: 'complex'
        message: 'Does this directive need an external html file?'
        default: true
      }
    ], ((answers) ->
      @filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '')
      @filters.complex = ! !answers.complex
      cb()
      return
    ).bind(this)
    return
  write: ->
    @sourceRoot path.join(__dirname, './templates/') + (if @filters.complex then 'complex' else 'simple')
    @filters.dir = @filters.dir + '/' + @filters.compname
    @filters.templateDir = @filters.dir.replace('src/client/', '')
    @destinationRoot path.join(process.cwd(), @filters.dir)
    genUtils.write this, @filters
    return