(function() {
  var fs, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      this.argument('name', {
        type: String,
        required: true
      });
    },
    prompts: function() {
      var cb;
      cb = this.async();
      return this.prompt([
        {
          type: 'list',
          name: 'app_type',
          message: 'What type of app would you like to create?',
          choices: ['Console', 'Web'],
          "default": 0,
          filter: function(val) {
            var filterMap;
            filterMap = {
              'Console': 'cli',
              'Web': 'web'
            };
            return filterMap[val];
          }
        }
      ], function(answers) {
        this.filters = {};
        this.filters.app_type = answers.app_type;
        console.log(this.filters);
        return typeof cb === "function" ? cb() : void 0;
      });
    }
  });

}).call(this);
