yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'
_ = require 'underscore.string'
_i = require 'underscore.inflection'
utils = require '../util.js'
 
bowerModules = ['jquery', 'angular', 'angular-touch', 'angular-ui-router', 'ndx-auth', 'ndx-scroll-top']
npmModules = ['ndx-server', 'ndx-static-routes', 'ndx-passport', 'ndx-modified', 'ndx-superadmin', 'ndx-permissions', 'ndx-user-roles']
generateId = (num) ->
  chars = 'abcdef1234567890'
  output = new Date().valueOf().toString(16)
  i = output.length
  while i++ < num
    output += chars[Math.floor(Math.random() * chars.length)]
  output
module.exports = yeoman.generators.Base.extend
  init: ->
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
          'Electron'
        ]
        default: 0
        filter: (val) ->
          filterMap =
            'Web': 'web'
            'Module': 'cli'
            'Electron': 'electron'
          filterMap[val]
      }
      {
        type: 'list'
        name: 'clientServer'
        message: 'Is this a server or clientside module?'
        when: (answers) ->
          answers.appType is 'cli'
        choices: [
          'Server'
          'Client'
        ]
        default: 0
        filter: (val) ->
          filterMap =
            'Server': 'server'
            'Client': 'client'
          filterMap[val]
      }
      {
        type: 'input'
        name: 'description'
        message: 'Type a description for your module'
        when: (answers) ->
          answers.appType is 'cli'
      }
      {
        type: 'input'
        name: 'encryptionKey'
        message: 'Encryption key'
        default: generateId 24
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'list'
        name: 'dbType'
        message: 'Database type'
        choices: ['Ndxdb', 'Mongo']
        default: 0
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'input'
        name: 'userTable'
        message: 'User table name'
        default: 'users'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'input'
        name: 'dbTables'
        message: 'Database Tables (comma seperated)'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'list'
        name: 'emails'
        message: 'Emails'
        choices: ['None', 'Smtp', 'Mailgun']
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'input'
        name: 'smtpUser'
        message: 'Smtp user'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('Smtp') isnt -1
      }
      {
        type: 'input'
        name: 'smtpPass'
        message: 'Smtp password'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('Smtp') isnt -1
      }
      {
        type: 'input'
        name: 'smtpHost'
        message: 'Smtp host'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('Smtp') isnt -1
      }
      {
        type: 'input'
        name: 'emailApiKey'
        message: 'Mailgun API key'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('Mailgun') isnt -1
      }
      {
        type: 'input'
        name: 'emailBaseUrl'
        message: 'Mailgun base url'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('Mailgun') isnt -1
      }
      {
        type: 'input'
        name: 'emailFrom'
        message: 'Email default from address'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('None') is -1
      }
      {
        type: 'input'
        name: 'emailOverride'
        message: 'Email override address'
        when: (answers) ->
          answers.appType is 'web' and answers.emails.indexOf('None') is -1
      }
      {
        type: 'confirm'
        name: 'rest'
        message: 'Rest?'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'confirm'
        name: 'cors'
        message: 'Cors?'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'confirm'
        name: 'localServer'
        message: 'Local server?'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'confirm'
        name: 'anonymousUser'
        message: 'Anonymous user?'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'confirm'
        name: 'profiler'
        message: 'Profiler?'
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'checkbox'
        name: 'loginMethods'
        message: 'Login methods'
        default: ['Local']
        choices: [
          'Local'
          'Twitter'
          'Facebook'
          'Github'
        ]
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'input'
        name: 'twitterKey'
        message: 'Twitter key'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Twitter') isnt -1
      }
      {
        type: 'input'
        name: 'twitterSecret'
        message: 'Twitter secret'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Twitter') isnt -1
      }
      {
        type: 'input'
        name: 'twitterCallback'
        message: 'Twitter callback url'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Twitter') isnt -1
      }
      {
        type: 'input'
        name: 'facebookKey'
        message: 'Facebook key'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Facebook') isnt -1
      }
      {
        type: 'input'
        name: 'facebookSecret'
        message: 'Facebook secret'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Facebook') isnt -1
      }
      {
        type: 'input'
        name: 'facebookCallback'
        message: 'Facebook callback url'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Facebook') isnt -1
      }
      {
        type: 'input'
        name: 'githubKey'
        message: 'Github key'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Github') isnt -1
      }
      {
        type: 'input'
        name: 'githubSecret'
        message: 'Github secret'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Github') isnt -1
      }
      {
        type: 'input'
        name: 'githubCallback'
        message: 'Github callback url'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Github') isnt -1
      }
      {
        type: 'confirm'
        name: 'userSignUp'
        message: 'User sign up?'
        when: (answers) ->
          answers.appType is 'web' and answers.loginMethods.indexOf('Local') isnt -1
      }
      {
        type: 'checkbox'
        name: 'directives'
        message: 'Directives'
        choices: [
          'Menu'
          'Header'
          'Footer'
        ]
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'checkbox'
        name: 'extras'
        message: 'Extras'
        choices: [
          'Invites'
          'Forgot password'
          'Form extras'
          'Message service'
          'Pagination'
          'Sorting'
          'File upload'
          'Server permissions'
          'Server decorator'
          'Server transforms'
          'Server templates'
        ]
        when: (answers) ->
          answers.appType is 'web'
      }
      {
        type: 'confirm'
        name: 'makeRoutesForEndpoints'
        message: 'Auto generate routes for endpoints?'
        when: (answers) ->
          answers.appType is 'web'
      }
    ], (answers) =>
      @filters = 
        settings: answers
      @filters.settings[answers.clientServer] = true
      @filters.settings.description = @filters.settings.description or 'ndx-framework web app'
      if @filters.settings.appType is 'web' 
        if @filters.settings.dbType is 'Mongo'
          npmModules.push 'ndx-mongo'
        if @filters.settings.rest
          npmModules.push 'ndx-rest'
          npmModules.push 'ndx-socket'
          bowerModules.push 'ndx-rest'
          bowerModules.push 'ndx-socket'
        if @filters.settings.profiler
          npmModules.push 'ndx-profiler'
        if @filters.settings.cors
          npmModules.push 'ndx-cors'
        for choice in @filters.settings.loginMethods
          switch choice
            when 'Twitter'
              npmModules.push 'ndx-passport-twitter'
            when 'Facebook'
              npmModules.push 'ndx-passport-facebook'
            when 'Github' 
              npmModules.push 'ndx-passport-github'
        @filters.settings.hasSocial = false
        for choice in @filters.settings.loginMethods
          if ['Twitter', 'Facebook', 'Github'].indexOf(choice) isnt -1
            @filters.settings.hasSocial = true
        @filters.settings.endpoints = []
        @filters.settings.endpoints.push @filters.settings.userTable
        if @filters.settings.dbTables
          for endpoint in @filters.settings.dbTables.split(/\s*,\s*/g)
            @filters.settings.endpoints.push endpoint
        for method in @filters.settings.loginMethods
          @filters.settings[_.camelize(method)] = true
        for directive in @filters.settings.directives
          @filters.settings[_.camelize(directive)] = true
        for extra in @filters.settings.extras
          @filters.settings[_.camelize(extra)] = true
        @filters.settings.myEndpoints = []
        for endpoint in @filters.settings.endpoints
          endpointPlural = _i.pluralize endpoint
          endpointSingle = _i.singularize endpoint
          if endpointPlural is endpointSingle
            endpointPlural += 's'
          @filters.settings.myEndpoints.push
            name: endpoint
            plural: endpointPlural
            single: endpointSingle
      cb?()
  setup: ->
    @filters.settings.appName = _.slugify _.dasherize @name
  checkForConfig: ->
    cb = @async()
    if @config.get('filters')
      @log 'The generator has already been run'
      return
    if fs.existsSync(process.cwd() + '/' + @filters.settings.appName)
      @log 'The generator has already been run.  CD into the directory'
      return
    cb()
    return
  write: ->
    cb = @async()
    @filters.settings.gitname = @user.git.name()
    @filters.settings.gitemail = @user.git.email()
    fs.mkdirSync @filters.settings.appName
    process.chdir process.cwd() + '/' + @filters.settings.appName
    @sourceRoot @templatePath('/' + @filters.settings.appType)
    @destinationRoot process.cwd()
    @config.set 'filters', @filters
    @config.set 'appname', @appname
    utils.write this, @filters, cb
    return
  end: ->
    cb = @async()
    subgenerators = []
    if @filters.settings.Local
      subgenerators.push ['ndx:login', '/src/client/directives/login']
    if @filters.settings.Menu
      subgenerators.push ['ndx:menu', '/src/client/directives/menu']
    if @filters.settings.Header
      subgenerators.push ['ndx:header', '/src/client/directives/header']
    if @filters.settings.Footer
      subgenerators.push ['ndx:footer', '/src/client/directives/footer']
    if @filters.settings.Invites
      subgenerators.push ['ndx:invited', '/src/client/routes/invited']
    if @filters.settings.ForgotPassword
      subgenerators.push ['ndx:forgot', '/src/client/routes/forgot']
    if @filters.settings.FormExtras
      subgenerators.push ['ndx:form-mixins', '/src/client/mixins']
    if @filters.settings.MessageService
      subgenerators.push ['ndx:message-service', '/src/client/services']
    if @filters.settings.FileUpload
      subgenerators.push ['ndx:file-utils', '/src/client/services']
    if @filters.settings.ServerDecorator
      subgenerators.push ['ndx:server-decorator', '/src/server/services']
    if @filters.settings.ServerPermissions
      subgenerators.push ['ndx:server-permissions', '/src/server/services']
    if @filters.settings.ServerTemplates
      subgenerators.push ['ndx:server-templates', '/src/server/services']
    if @filters.settings.ServerTransforms
      subgenerators.push ['ndx:server-transforms', '/src/server/services']
    if @filters.settings.makeRoutesForEndpoints
      for endpoint in @filters.settings.myEndpoints
        subgenerators.push ['ndx:route', endpoint.plural, "/src/client/routes/#{endpoint.plural}", endpoint.plural, "['anon']", 'List', endpoint.name, 'none']
        subgenerators.push ['ndx:route', endpoint.single, "/src/client/routes/#{endpoint.single}", endpoint.single, "['anon']", 'Item', endpoint.name, ':_id']
    noRoutes = 0
    makeRoute = =>
      noRoutes++
      @prompt [
        {
          name: 'makeRoute'
          message: if noRoutes is 1 then 'Make a route?' else 'Make another route?'
          type: 'confirm'
        }
      ], (answers) =>
        if answers.makeRoute
          utils.spawnSync 'yo', ['ndx:route'], makeRoute
        else
          console.log '\n\nYour app has been built and is ready to run'
          console.log 'type'
          console.log '  cd ' + @filters.settings.appName
          console.log '  env.bat'
          console.log '  grunt'
          console.log 'to get started\n'
    i = -1
    self = @
    runNextGenerator = ->
      if i++ < subgenerators.length - 1
        utils.spawnSync 'yo', subgenerators[i], runNextGenerator
      else
        if self.filters.settings.appType is 'web'
          makeRoute()
    runNextGenerator()
    return
  
  installDeps: ->
    if @filters.settings.appType is 'web'
      if @filters.settings.FormExtras
        bowerModules.push 'ndx-form-extras'
        bowerModules.push 'ndx-check-for-changes'
      if @filters.settings.Pagination
        bowerModules.push 'ndx-pagination'
      if @filters.settings.Sorting
        bowerModules.push 'ndx-sorter'
      if @filters.settings.localServer
        bowerModules.push 'ndxdb'
        bowerModules.push 'ndx-local-settings'
        bowerModules.push 'ndx-local-server'
      if @filters.settings.profiler
        npmModules.push 'ndx-profiler'
      if @filters.settings.FileUpload
        npmModules.push 'ndx-file-upload'
        bowerModules.push 'ng-file-upload'
      console.log 'installing dev modules'
      @npmInstall ['grunt', 'grunt-angular-templates', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-contrib-watch', 'grunt-express-server', 'grunt-file-append', 'grunt-filerev', 'grunt-injector', 'grunt-keepalive', 'grunt-ndxmin', 'grunt-ngmin', 'grunt-usemin', 'grunt-wiredep', 'grunt-ndx-script-inject', 'load-grunt-tasks'], 
        saveDev: true
        silent: true
      , =>
        console.log 'installing server modules'
        @npmInstall npmModules, 
          save: true
          silent: true
        , =>
          console.log 'installing client modules'
          @bowerInstall bowerModules, 
            save: true
            silent: true
    else if @filters.settings.appType is 'cli'
      console.log 'installing dev modules'
      @npmInstall ['grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-nodeunit', 'grunt-contrib-watch', 'load-grunt-tasks'], 
        saveDev: true
        silent: true
      , =>
        utils.launchGrunt @
    else
      console.log 'installing dev modules'
      @npmInstall ['electron', 'electron-builder', 'grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-pug', 'grunt-contrib-watch', 'load-grunt-tasks'],
        saveDev: true
        silent: true
      , =>
        @npmInstall ['electron-updater'],
          save: true
          silent: true
        , =>
          utils.launchGrunt @
    return