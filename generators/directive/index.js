(function() {
  var _, fs, genUtils, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  genUtils = require('../util');

  _ = require('underscore.string');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      this.argument('compname', {
        type: String,
        required: true
      });
      return this.compname = _.slugify(_.humanize(this.compname));
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      if (this.config.get('filters')) {
        this.filters = this.config.get('filters');
        this.filters.compname = this.compname;
        this.filters.compnameCamel = _.camelize(this.compname);
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
          message: 'Where would you like to create this directive?',
          "default": "/src/client/directives/" + this.filters.compname
        }, {
          type: 'confirm',
          name: 'complex',
          message: 'Does this directive need an external html file?',
          "default": true
        }
      ], (function(answers) {
        this.filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '');
        this.filters.complex = !!answers.complex;
        cb();
      }).bind(this));
    },
    write: function() {
      this.sourceRoot(path.join(__dirname, './templates/') + (this.filters.complex ? 'complex' : 'simple'));
      this.filters.templateDir = this.filters.dir.replace('src/client/', '');
      this.destinationRoot(path.join(process.cwd(), this.filters.dir));
      genUtils.write(this, this.filters);
    }
  });

}).call(this);
