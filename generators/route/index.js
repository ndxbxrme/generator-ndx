(function() {
  var _, fs, genUtils, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  genUtils = require('../util');

  _ = require('underscore.string');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      return this.argument('compname', {
        type: String,
        required: true
      });
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
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
    },
    askFor: function() {
      var cb;
      cb = this.async();
      this.prompt([
        {
          name: 'dir',
          message: 'Where would you like to create this route?',
          "default": "/src/client/routes/" + this.filters.compname
        }, {
          name: 'roles',
          message: 'User roles',
          "default": ''
        }, {
          name: 'parameters',
          message: 'Parameters (eg. :id/something/:another)',
          "default": ''
        }
      ], (function(answers) {
        this.filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '');
        this.filters.roles = answers.roles;
        this.filters.parameters = answers.parameters;
        cb();
      }).bind(this));
    },
    write: function() {
      this.sourceRoot(path.join(__dirname, './templates/'));
      this.filters.templateDir = this.filters.dir.replace('src/client/', '');
      this.destinationRoot(path.join(process.cwd(), this.filters.dir));
      genUtils.write(this, this.filters);
    }
  });

}).call(this);
