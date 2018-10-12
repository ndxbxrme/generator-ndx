(function() {
  var _, _i, fs, genUtils, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  genUtils = require('../util');

  _ = require('underscore.string');

  _i = require('underscore.inflection');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      this.argument('compname', {
        type: String,
        required: false
      });
      this.argument('dir', {
        type: String,
        required: false
      });
      this.argument('title', {
        type: String,
        required: false
      });
      this.argument('roles', {
        type: String,
        required: false
      });
      this.argument('type', {
        type: String,
        required: false
      });
      this.argument('endpoint', {
        type: String,
        required: false
      });
      return this.argument('parameters', {
        type: String,
        required: false
      });
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      if (!this.compname) {
        return this.prompt([
          {
            name: 'compname',
            message: 'Route name',
            when: function() {
              return !this.compname;
            }
          }
        ], (function(_this) {
          return function(answers) {
            if (answers.compname) {
              _this.compname = answers.compname;
            }
            if (_this.config.get('filters')) {
              _this.filters = _this.config.get('filters');
              _this.filters.compname = _this.compname;
              _this.filters.compnameSlugged = _.slugify(_.humanize(_this.compname));
              _this.filters.compnameCamel = _.camelize(_this.filters.compnameSlugged);
              _this.filters.compnameCapped = _.capitalize(_this.filters.compnameCamel).replace('-', '');
              _this.compname = _.slugify(_.humanize(_this.compname));
              _this.filters.compname = _this.compname;
            } else {
              _this.log('Cannot find the config file');
              return;
            }
            return cb();
          };
        })(this));
      } else {
        if (this.config.get('filters')) {
          this.filters = this.config.get('filters');
          this.filters.compname = this.compname;
          this.filters.compnameSlugged = _.slugify(_.humanize(this.compname));
          this.filters.compnameCamel = _.camelize(this.filters.compnameSlugged);
          this.filters.compnameCapped = _.capitalize(this.filters.compnameCamel).replace('-', '');
          this.compname = _.slugify(_.humanize(this.compname));
          this.filters.compname = this.compname;
        } else {
          this.log('Cannot find the config file');
          return;
        }
        return cb();
      }
    },
    askFor: function() {
      var cb;
      cb = this.async();
      this.prompt([
        {
          name: 'dir',
          message: 'Where would you like to create this route?',
          "default": "/src/client/routes/" + this.filters.compname,
          when: (function(_this) {
            return function() {
              return !_this.dir;
            };
          })(this)
        }, {
          name: 'title',
          message: 'Page title',
          "default": this.filters.compname,
          when: (function(_this) {
            return function() {
              return !_this.title;
            };
          })(this)
        }, {
          name: 'roles',
          message: 'User roles',
          "default": '[]',
          when: (function(_this) {
            return function() {
              return !_this.roles;
            };
          })(this)
        }, {
          name: 'type',
          type: 'list',
          message: 'Page type',
          choices: ['Empty', 'List', 'Item'],
          "default": 0,
          when: (function(_this) {
            return function() {
              return !_this.type;
            };
          })(this)
        }, {
          name: 'endpoint',
          message: 'Endpoint',
          type: 'list',
          choices: this.filters.endpoints,
          when: (function(_this) {
            return function(answers) {
              return answers.type !== 'Empty' && !_this.endpoint;
            };
          })(this)
        }, {
          name: 'parameters',
          message: 'Parameters (eg. :id/something/:another)',
          "default": '',
          when: (function(_this) {
            return function() {
              return !_this.parameters;
            };
          })(this)
        }
      ], (function(answers) {
        answers.endpoint = answers.endpoint || this.endpoint;
        if (answers.endpoint) {
          this.filters.endpoint = answers.endpoint;
          this.filters.endpointPlural = _i.pluralize(this.filters.endpoint);
          this.filters.endpointSingle = _i.singularize(this.filters.endpoint);
          if (this.filters.endpointPlural === this.filters.endpointSingle) {
            this.filters.endpointPlural += 's';
          }
        }
        this.filters.dir = (answers.dir || this.dir).replace(/\/$/, '').replace(/^\//, '');
        this.filters.roles = answers.roles || this.roles;
        this.filters.parameters = answers.parameters || this.parameters;
        if (this.filters.parameters === 'none') {
          this.filters.parameters = '';
        }
        this.filters.title = answers.title || this.title;
        this.filters.type = answers.type || this.type;
        cb();
      }).bind(this));
    },
    write: function() {
      this.sourceRoot(path.join(__dirname, './templates/', this.filters.type));
      this.filters.templateDir = this.filters.dir.replace('src/client/', '');
      this.destinationRoot(path.join(process.cwd(), this.filters.dir));
      genUtils.write(this, this.filters);
    }
  });

}).call(this);
