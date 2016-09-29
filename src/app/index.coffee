yeoman = require 'yeoman-generator'
fs = require 'fs'
path = require 'path'

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
        name: 'app_type'
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
    ], (answers) ->
      @filters = {}
      @filters.app_type = answers.app_type
      console.log @filters
      cb?()
      