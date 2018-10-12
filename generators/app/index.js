(function() {
  var _, _i, bowerModules, fs, generateId, npmModules, path, utils, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  _ = require('underscore.string');

  _i = require('underscore.inflection');

  utils = require('../util.js');

  bowerModules = ['jquery', 'angular', 'angular-touch', 'angular-ui-router', 'ndx-auth', 'ndx-scroll-top'];

  npmModules = ['ndx-server', 'ndx-static-routes', 'ndx-passport', 'ndx-modified', 'ndx-superadmin', 'ndx-permissions', 'ndx-user-roles'];

  generateId = function(num) {
    var chars, i, output;
    chars = 'abcdef1234567890';
    output = new Date().valueOf().toString(16);
    i = output.length;
    while (i++ < num) {
      output += chars[Math.floor(Math.random() * chars.length)];
    }
    return output;
  };

  module.exports = yeoman.generators.Base.extend({
    init: function() {
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
          choices: ['Web', 'Module', 'Electron'],
          "default": 0,
          filter: function(val) {
            var filterMap;
            filterMap = {
              'Web': 'web',
              'Module': 'cli',
              'Electron': 'electron'
            };
            return filterMap[val];
          }
        }, {
          type: 'list',
          name: 'clientServer',
          message: 'Is this a server or clientside module?',
          when: function(answers) {
            return answers.appType === 'cli';
          },
          choices: ['Server', 'Client'],
          "default": 0,
          filter: function(val) {
            var filterMap;
            filterMap = {
              'Server': 'server',
              'Client': 'client'
            };
            return filterMap[val];
          }
        }, {
          type: 'input',
          name: 'description',
          message: 'Type a description for your module',
          when: function(answers) {
            return answers.appType === 'cli';
          }
        }, {
          type: 'input',
          name: 'encryptionKey',
          message: 'Encryption key',
          "default": generateId(24),
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'list',
          name: 'dbType',
          message: 'Database type',
          choices: ['Ndxdb', 'Mongo'],
          "default": 0,
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'input',
          name: 'userTable',
          message: 'User table name',
          "default": 'users',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'input',
          name: 'dbTables',
          message: 'Database Tables (comma seperated)',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'list',
          name: 'emails',
          message: 'Emails',
          choices: ['None', 'Smtp', 'Mailgun'],
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'input',
          name: 'smtpUser',
          message: 'Smtp user',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('Smtp') !== -1;
          }
        }, {
          type: 'input',
          name: 'smtpPass',
          message: 'Smtp password',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('Smtp') !== -1;
          }
        }, {
          type: 'input',
          name: 'smtpHost',
          message: 'Smtp host',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('Smtp') !== -1;
          }
        }, {
          type: 'input',
          name: 'emailApiKey',
          message: 'Mailgun API key',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('Mailgun') !== -1;
          }
        }, {
          type: 'input',
          name: 'emailBaseUrl',
          message: 'Mailgun base url',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('Mailgun') !== -1;
          }
        }, {
          type: 'input',
          name: 'emailFrom',
          message: 'Email default from address',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('None') === -1;
          }
        }, {
          type: 'input',
          name: 'emailOverride',
          message: 'Email override address',
          when: function(answers) {
            return answers.appType === 'web' && answers.emails.indexOf('None') === -1;
          }
        }, {
          type: 'confirm',
          name: 'rest',
          message: 'Rest?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'confirm',
          name: 'cors',
          message: 'Cors?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'confirm',
          name: 'localServer',
          message: 'Local server?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'confirm',
          name: 'anonymousUser',
          message: 'Anonymous user?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'confirm',
          name: 'profiler',
          message: 'Profiler?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'checkbox',
          name: 'loginMethods',
          message: 'Login methods',
          "default": ['Local'],
          choices: ['Local', 'Twitter', 'Facebook', 'Github'],
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'input',
          name: 'twitterKey',
          message: 'Twitter key',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Twitter') !== -1;
          }
        }, {
          type: 'input',
          name: 'twitterSecret',
          message: 'Twitter secret',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Twitter') !== -1;
          }
        }, {
          type: 'input',
          name: 'twitterCallback',
          message: 'Twitter callback url',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Twitter') !== -1;
          }
        }, {
          type: 'input',
          name: 'facebookKey',
          message: 'Facebook key',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Facebook') !== -1;
          }
        }, {
          type: 'input',
          name: 'facebookSecret',
          message: 'Facebook secret',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Facebook') !== -1;
          }
        }, {
          type: 'input',
          name: 'facebookCallback',
          message: 'Facebook callback url',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Facebook') !== -1;
          }
        }, {
          type: 'input',
          name: 'githubKey',
          message: 'Github key',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Github') !== -1;
          }
        }, {
          type: 'input',
          name: 'githubSecret',
          message: 'Github secret',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Github') !== -1;
          }
        }, {
          type: 'input',
          name: 'githubCallback',
          message: 'Github callback url',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Github') !== -1;
          }
        }, {
          type: 'confirm',
          name: 'userSignUp',
          message: 'User sign up?',
          when: function(answers) {
            return answers.appType === 'web' && answers.loginMethods.indexOf('Local') !== -1;
          }
        }, {
          type: 'checkbox',
          name: 'directives',
          message: 'Directives',
          choices: ['Menu', 'Header', 'Footer'],
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'checkbox',
          name: 'extras',
          message: 'Extras',
          choices: ['Invites', 'Forgot password', 'Form extras', 'Message service', 'Pagination', 'Sorting', 'File upload', 'Server permissions', 'Server decorator', 'Server transforms', 'Server templates'],
          when: function(answers) {
            return answers.appType === 'web';
          }
        }, {
          type: 'confirm',
          name: 'makeRoutesForEndpoints',
          message: 'Auto generate routes for endpoints?',
          when: function(answers) {
            return answers.appType === 'web';
          }
        }
      ], (function(_this) {
        return function(answers) {
          var choice, directive, endpoint, endpointPlural, endpointSingle, extra, j, k, l, len, len1, len2, len3, len4, len5, len6, m, method, n, o, p, ref, ref1, ref2, ref3, ref4, ref5, ref6;
          _this.filters = {
            settings: answers
          };
          _this.filters.settings[answers.clientServer] = true;
          _this.filters.settings.description = _this.filters.settings.description || 'ndx-framework web app';
          if (_this.filters.settings.appType === 'web') {
            if (_this.filters.settings.dbType === 'Mongo') {
              npmModules.push('ndx-mongo');
            }
            if (_this.filters.settings.rest) {
              npmModules.push('ndx-rest');
              npmModules.push('ndx-socket');
              bowerModules.push('ndx-rest');
              bowerModules.push('ndx-socket');
            }
            if (_this.filters.settings.profiler) {
              npmModules.push('ndx-profiler');
            }
            if (_this.filters.settings.cors) {
              npmModules.push('ndx-cors');
            }
            ref = _this.filters.settings.loginMethods;
            for (j = 0, len = ref.length; j < len; j++) {
              choice = ref[j];
              switch (choice) {
                case 'Twitter':
                  npmModules.push('ndx-passport-twitter');
                  break;
                case 'Facebook':
                  npmModules.push('ndx-passport-facebook');
                  break;
                case 'Github':
                  npmModules.push('ndx-passport-github');
              }
            }
            _this.filters.settings.hasSocial = false;
            ref1 = _this.filters.settings.loginMethods;
            for (k = 0, len1 = ref1.length; k < len1; k++) {
              choice = ref1[k];
              if (['Twitter', 'Facebook', 'Github'].indexOf(choice) !== -1) {
                _this.filters.settings.hasSocial = true;
              }
            }
            _this.filters.settings.endpoints = [];
            _this.filters.settings.endpoints.push(_this.filters.settings.userTable);
            if (_this.filters.settings.dbTables) {
              ref2 = _this.filters.settings.dbTables.split(/\s*,\s*/g);
              for (l = 0, len2 = ref2.length; l < len2; l++) {
                endpoint = ref2[l];
                _this.filters.settings.endpoints.push(endpoint);
              }
            }
            ref3 = _this.filters.settings.loginMethods;
            for (m = 0, len3 = ref3.length; m < len3; m++) {
              method = ref3[m];
              _this.filters.settings[_.camelize(method)] = true;
            }
            ref4 = _this.filters.settings.directives;
            for (n = 0, len4 = ref4.length; n < len4; n++) {
              directive = ref4[n];
              _this.filters.settings[_.camelize(directive)] = true;
            }
            ref5 = _this.filters.settings.extras;
            for (o = 0, len5 = ref5.length; o < len5; o++) {
              extra = ref5[o];
              _this.filters.settings[_.camelize(extra)] = true;
            }
            _this.filters.settings.myEndpoints = [];
            ref6 = _this.filters.settings.endpoints;
            for (p = 0, len6 = ref6.length; p < len6; p++) {
              endpoint = ref6[p];
              endpointPlural = _i.pluralize(endpoint);
              endpointSingle = _i.singularize(endpoint);
              if (endpointPlural === endpointSingle) {
                endpointPlural += 's';
              }
              _this.filters.settings.myEndpoints.push({
                name: endpoint,
                plural: endpointPlural,
                single: endpointSingle
              });
            }
          }
          return typeof cb === "function" ? cb() : void 0;
        };
      })(this));
    },
    setup: function() {
      return this.filters.settings.appName = _.slugify(_.dasherize(this.name));
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      if (this.config.get('filters')) {
        this.log('The generator has already been run');
        return;
      }
      if (fs.existsSync(process.cwd() + '/' + this.filters.settings.appName)) {
        this.log('The generator has already been run.  CD into the directory');
        return;
      }
      cb();
    },
    write: function() {
      var cb;
      cb = this.async();
      this.filters.settings.gitname = this.user.git.name();
      this.filters.settings.gitemail = this.user.git.email();
      fs.mkdirSync(this.filters.settings.appName);
      process.chdir(process.cwd() + '/' + this.filters.settings.appName);
      this.sourceRoot(this.templatePath('/' + this.filters.settings.appType));
      this.destinationRoot(process.cwd());
      this.config.set('filters', this.filters);
      this.config.set('appname', this.appname);
      utils.write(this, this.filters, cb);
    },
    end: function() {
      var cb, endpoint, i, j, len, makeRoute, noRoutes, ref, runNextGenerator, self, subgenerators;
      cb = this.async();
      subgenerators = [];
      if (this.filters.settings.Local) {
        subgenerators.push(['ndx:login', '/src/client/directives/login']);
      }
      if (this.filters.settings.Menu) {
        subgenerators.push(['ndx:menu', '/src/client/directives/menu']);
      }
      if (this.filters.settings.Header) {
        subgenerators.push(['ndx:header', '/src/client/directives/header']);
      }
      if (this.filters.settings.Footer) {
        subgenerators.push(['ndx:footer', '/src/client/directives/footer']);
      }
      if (this.filters.settings.Invites) {
        subgenerators.push(['ndx:invited', '/src/client/routes/invited']);
      }
      if (this.filters.settings.ForgotPassword) {
        subgenerators.push(['ndx:forgot', '/src/client/routes/forgot']);
      }
      if (this.filters.settings.FormExtras) {
        subgenerators.push(['ndx:form-mixins', '/src/client/mixins']);
      }
      if (this.filters.settings.MessageService) {
        subgenerators.push(['ndx:message-service', '/src/client/services']);
      }
      if (this.filters.settings.FileUpload) {
        subgenerators.push(['ndx:file-utils', '/src/client/services']);
      }
      if (this.filters.settings.ServerDecorator) {
        subgenerators.push(['ndx:server-decorator', '/src/server/services']);
      }
      if (this.filters.settings.ServerPermissions) {
        subgenerators.push(['ndx:server-permissions', '/src/server/services']);
      }
      if (this.filters.settings.ServerTemplates) {
        subgenerators.push(['ndx:server-templates', '/src/server/services']);
      }
      if (this.filters.settings.ServerTransforms) {
        subgenerators.push(['ndx:server-transforms', '/src/server/services']);
      }
      if (this.filters.settings.makeRoutesForEndpoints) {
        ref = this.filters.settings.myEndpoints;
        for (j = 0, len = ref.length; j < len; j++) {
          endpoint = ref[j];
          subgenerators.push(['ndx:route', endpoint.plural, "/src/client/routes/" + endpoint.plural, endpoint.plural, "['anon']", 'List', endpoint.name, 'none']);
          subgenerators.push(['ndx:route', endpoint.single, "/src/client/routes/" + endpoint.single, endpoint.single, "['anon']", 'Item', endpoint.name, ':_id']);
        }
      }
      noRoutes = 0;
      makeRoute = (function(_this) {
        return function() {
          noRoutes++;
          return _this.prompt([
            {
              name: 'makeRoute',
              message: noRoutes === 1 ? 'Make a route?' : 'Make another route?',
              type: 'confirm'
            }
          ], function(answers) {
            if (answers.makeRoute) {
              return utils.spawnSync('yo', ['ndx:route'], makeRoute);
            } else {
              console.log('\n\nYour app has been built and is ready to run');
              console.log('type');
              console.log('  cd ' + _this.filters.settings.appName);
              console.log('  env.bat');
              console.log('  grunt');
              return console.log('to get started\n');
            }
          });
        };
      })(this);
      i = -1;
      self = this;
      runNextGenerator = function() {
        if (i++ < subgenerators.length - 1) {
          return utils.spawnSync('yo', subgenerators[i], runNextGenerator);
        } else {
          if (self.filters.settings.appType === 'web') {
            return makeRoute();
          }
        }
      };
      runNextGenerator();
    },
    installDeps: function() {
      if (this.filters.settings.appType === 'web') {
        if (this.filters.settings.FormExtras) {
          bowerModules.push('ndx-form-extras');
          bowerModules.push('ndx-check-for-changes');
        }
        if (this.filters.settings.Pagination) {
          bowerModules.push('ndx-pagination');
        }
        if (this.filters.settings.Sorting) {
          bowerModules.push('ndx-sorter');
        }
        if (this.filters.settings.localServer) {
          bowerModules.push('ndxdb');
          bowerModules.push('ndx-local-settings');
          bowerModules.push('ndx-local-server');
        }
        if (this.filters.settings.profiler) {
          npmModules.push('ndx-profiler');
        }
        if (this.filters.settings.FileUpload) {
          npmModules.push('ndx-file-upload');
          bowerModules.push('ng-file-upload');
        }
        console.log('installing dev modules');
        this.npmInstall(['grunt', 'grunt-angular-templates', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-jade', 'grunt-contrib-stylus', 'grunt-contrib-watch', 'grunt-express-server', 'grunt-file-append', 'grunt-filerev', 'grunt-injector', 'grunt-keepalive', 'grunt-ndxmin', 'grunt-ngmin', 'grunt-usemin', 'grunt-wiredep', 'grunt-ndx-script-inject', 'load-grunt-tasks'], {
          saveDev: true,
          silent: true
        }, (function(_this) {
          return function() {
            console.log('installing server modules');
            return _this.npmInstall(npmModules, {
              save: true,
              silent: true
            }, function() {
              console.log('installing client modules');
              return _this.bowerInstall(bowerModules, {
                save: true,
                silent: true
              });
            });
          };
        })(this));
      } else if (this.filters.settings.appType === 'cli') {
        console.log('installing dev modules');
        this.npmInstall(['grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-nodeunit', 'grunt-contrib-watch', 'load-grunt-tasks'], {
          saveDev: true,
          silent: true
        }, (function(_this) {
          return function() {
            return utils.launchGrunt(_this);
          };
        })(this));
      } else {
        console.log('installing dev modules');
        this.npmInstall(['electron', 'electron-builder', 'grunt', 'grunt-cli', 'grunt-contrib-clean', 'grunt-contrib-coffee', 'grunt-contrib-copy', 'grunt-contrib-pug', 'grunt-contrib-watch', 'load-grunt-tasks'], {
          saveDev: true,
          silent: true
        }, (function(_this) {
          return function() {
            return _this.npmInstall(['electron-updater'], {
              save: true,
              silent: true
            }, function() {
              return utils.launchGrunt(_this);
            });
          };
        })(this));
      }
    }
  });

}).call(this);
