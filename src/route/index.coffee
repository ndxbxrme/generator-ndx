yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
genUtils = require '../util'
_ = require 'underscore.string'
_i = require 'underscore.inflection'

module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'compname',
      type: String
      required: false
    @argument 'dir',
      type: String
      required: false
    @argument 'title',
      type: String
      required: false
    @argument 'roles',
      type: String
      required: false
    @argument 'type',
      type: String
      required: false
    @argument 'endpoint',
      type: String
      required: false
    @argument 'parameters',
      type: String
      required: false
  checkForConfig: ->
    cb = @async()
    if not @compname
      @prompt [
        {
          name: 'compname'
          message: 'Route name'
          when: ->
            not @compname
        }
      ], (answers) =>
        if answers.compname
          @compname = answers.compname
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
    else
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
        when: =>
          not @dir
      }
      {
        name: 'title'
        message: 'Page title'
        default: @filters.compname
        when: =>
          not @title
      }
      {
        name: 'roles'
        message: 'User roles'
        default: '[]'
        when: =>
          not @roles
      }
      {
        name: 'type'
        type: 'list'
        message: 'Page type'
        choices: [
          'Empty'
          'List'
          'Item'
        ]
        default: 0
        when: =>
          not @type
      }
      {
        name: 'endpoint'
        message: 'Endpoint'
        type: 'list'
        choices: @filters.endpoints
        when: (answers) =>
          answers.type isnt 'Empty' and not @endpoint          
      }
      {
        name: 'parameters'
        message: 'Parameters (eg. :id/something/:another)'
        default: ''
        when: =>
          not @parameters
      }
    ], ((answers) ->
      answers.endpoint = answers.endpoint or @endpoint
      if answers.endpoint
        @filters.endpoint = answers.endpoint
        @filters.endpointPlural = _i.pluralize @filters.endpoint
        @filters.endpointSingle = _i.singularize @filters.endpoint
        if @filters.endpointPlural is @filters.endpointSingle
          @filters.endpointPlural += 's'
      @filters.dir = (answers.dir or @dir).replace(/\/$/, '').replace(/^\//, '')
      @filters.roles = answers.roles or @roles
      @filters.parameters = answers.parameters or @parameters
      if @filters.parameters is 'none'
        @filters.parameters = ''
      @filters.title = answers.title or @title
      @filters.type = answers.type or @type
      cb()
      return
    ).bind(this)
    return
  write: ->
    @sourceRoot path.join(__dirname, './templates/', @filters.type)
    @filters.templateDir = @filters.dir.replace('src/client/', '')
    @destinationRoot path.join(process.cwd(), @filters.dir)
    genUtils.write this, @filters
    return