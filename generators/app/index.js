(function() {
  var _, fs, path, utils, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  _ = require('underscore.string');

  utils = require('../util.js');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      console.log('hey');
      this.argument('name', {
        type: String,
        required: true
      });
      console.log(this.name);
    },
    prompts: function() {
      var cb;
      cb = this.async();
      return this.prompt([
        {
          type: 'list',
          name: 'appType',
          message: 'What type of app would you like to create?',
          choices: ['Web', 'Module'],
          "default": 0,
          filter: function(val) {
            var filterMap;
            filterMap = {
              'Web': 'web',
              'Module': 'cli'
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
      this.destinationRoot(process.cwd());
      this.config.set('filters', this.filters);
      this.config.set('appname', this.appname);
      utils.write(this, this.filters, cb);
    },
    installDeps: function() {
      if (this.filters.appType === 'web') {
        console.log('installing dev modules');
        this.npmInstall(['grunt', 'grunt-angular-templates', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-contrib-watch', 'grunt-express-server', 'grunt-file-append', 'grunt-filerev', 'grunt-injector', 'grunt-keepalive', 'grunt-ndxmin', 'grunt-ngmin', 'grunt-usemin', 'grunt-wiredep', 'load-grunt-tasks'], {
          saveDev: true,
          silent: true
        }, (function(_this) {
          return function() {
            console.log('installing server modules');
            return _this.npmInstall(['ndx-server', 'ndx-static-routes'], {
              save: true,
              silent: true
            }, function() {
              console.log('installing client modules');
              return _this.bowerInstall(['jquery', 'angular', 'angular-touch', 'angular-ui-router'], {
                save: true,
                silent: true
              }, function() {
                return utils.launchGrunt(_this);
              });
            });
          };
        })(this));
      } else {
        console.log('installing dev modules');
        this.npmInstall(['grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-nodeunit', 'grunt-contrib-watch', 'load-grunt-tasks'], {
          saveDev: true,
          silent: true
        }, (function(_this) {
          return function() {
            return utils.launchGrunt(_this);
          };
        })(this));
      }
    }
  });

}).call(this);
