yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
_ = require 'underscore.string'
utils = require '../util.js'


module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'name',
      type: String
      required: true
    return
  prompts: ->
    cb = @async()
    @prompt [
      {
        type: 'list'
        name: 'appType'
        message: 'What type of app would you like to create?'
        choices: [
          'Console'
          'Web'
        ]
        default: 0
        filter: (val) ->
          filterMap =
            'Console': 'cli'
            'Web': 'web'
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
    utils.write this, @filters, cb
    return
  installDeps: ->
    @npmInstall ['grunt', 'grunt-cli', 'grunt-contrib-coffee', 'grunt-contrib-watch', 'load-grunt-tasks'],
      saveDev: true, =>
        if @filters.appType is 'web'
          @npmInstall ['grunt-contrib-connect', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-injector', 'grunt-wiredep', 'serve-static'],
            saveDev: true, =>
              @bowerInstall ['jquery'],
                save: true, =>
                  utils.launchGrunt this
        else
          utils.launchGrunt this
    return