(function() {
  var _, fs, path, utils, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  _ = require('underscore.string');

  utils = require('../util.js');

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
          name: 'appType',
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
      ], (function(_this) {
        return function(answers) {
          _this.filters = {};
          _this.filters.appType = answers.appType;
          return typeof cb === "function" ? cb() : void 0;
        };
      })(this));
    },
    setup: function() {
      return this.filters.appName = _.slugify(_.dasherize(this.name));
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      if (this.config.get('filters')) {
        this.log('The generator has already been run');
        return;
      }
      if (fs.existsSync(process.cwd() + '/' + this.filters.appName)) {
        this.log('The generator has already been run.  CD into the directory');
        return;
      }
      cb();
    },
    write: function() {
      var cb;
      cb = this.async();
      fs.mkdirSync(this.filters.appName);
      process.chdir(process.cwd() + '/' + this.filters.appName);
      this.sourceRoot(this.templatePath('/' + this.filters.appType));
      utils.write(this, this.filters, cb);
    },
    installDeps: function() {
      this.npmInstall(['grunt', 'grunt-cli', 'grunt-contrib-coffee', 'grunt-contrib-watch', 'load-grunt-tasks'], {
        saveDev: true
      }, (function(_this) {
        return function() {
          if (_this.filters.appType === 'web') {
            return _this.npmInstall(['grunt-contrib-connect', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-injector', 'grunt-wiredep', 'serve-static'], {
              saveDev: true
            }, function() {
              return _this.bowerInstall(['jquery'], {
                save: true
              }, function() {
                return utils.launchGrunt(_this);
              });
            });
          } else {
            return utils.launchGrunt(_this);
          }
        };
      })(this));
    }
  });

}).call(this);
