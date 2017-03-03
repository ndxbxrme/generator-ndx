yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
_ = require 'underscore.string'
utils = require '../util.js'
 
module.exports = yeoman.generators.Base.extend
  init: ->
    console.log 'hey'
    @argument 'name',
      type: String
      required: true
    console.log @name
    return
  prompts: ->
    cb = @async()
    @prompt [
      {
        type: 'list'
        name: 'appType'
        message: 'What type of app would you like to create?'
        choices: [
          'Web'
          'Module'
        ]
        default: 0
        filter: (val) ->
          filterMap =
            'Web': 'web'
            'Module': 'cli'
          filterMap[val]
      }
    ], (answers) =>
      @filters = {}
      @filters.appType = answers.appType
      cb?()
  setup: ->
    @filters.appName = _.slugify _.dasherize @name
  checkForConfig: ->
    cb = @async()
    if @config.get('filters')
      @log 'The generator has already been run'
      return
    if fs.existsSync(process.cwd() + '/' + @filters.appName)
      @log 'The generator has already been run.  CD into the directory'
      return
    cb()
    return
  write: ->
    cb = @async()
    fs.mkdirSync @filters.appName
    process.chdir process.cwd() + '/' + @filters.appName
    @sourceRoot @templatePath('/' + @filters.appType)
    @destinationRoot process.cwd()
    @config.set 'filters', @filters
    @config.set 'appname', @appname
    utils.write this, @filters, cb
    return
  installDeps: ->
    if @filters.appType is 'web'
      console.log 'installing dev modules'
      @npmInstall ['grunt', 'grunt-angular-templates', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-contrib-watch', 'grunt-express-server', 'grunt-file-append', 'grunt-filerev', 'grunt-injector', 'grunt-keepalive', 'grunt-ndxmin', 'grunt-ngmin', 'grunt-usemin', 'grunt-wiredep', 'load-grunt-tasks'], 
        saveDev: true
        silent: true
      , =>
        console.log 'installing server modules'
        @npmInstall ['ndx-server', 'ndx-static-routes'], 
          save: true
          silent: true
        , =>
          console.log 'installing client modules'
          @bowerInstall ['jquery', 'angular', 'angular-touch', 'angular-ui-router'], 
            save: true
            silent: true
          , =>
            utils.launchGrunt @
    else
      console.log 'installing dev modules'
      @npmInstall ['grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-nodeunit', 'grunt-contrib-watch', 'load-grunt-tasks'], 
        saveDev: true
        silent: true
      , =>
        utils.launchGrunt @
    return