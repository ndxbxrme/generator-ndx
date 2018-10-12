(function() {
  var _, fs, genUtils, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  genUtils = require('../util');

  _ = require('underscore.string');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      return this.argument('dir', {
        type: String,
        required: false
      });
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      this.projectDir = process.cwd();
      if (this.config.get('filters')) {
        this.filters = this.config.get('filters');
      } else {
        this.log('Cannot find the config file');
        return;
      }
      return cb();
    },
    askFor: function() {
      var cb;
      cb = this.async();
      if (!this.dir) {
        this.prompt([
          {
            name: 'dir',
            message: 'Where would you like to create this directive?',
            "default": '/src/client/directives/footer'
          }
        ], (function(answers) {
          this.filters.dir = answers.dir.replace(/\/$/, '').replace(/^\//, '');
          cb();
        }).bind(this));
      } else {
        cb();
      }
    },
    write: function() {
      this.filters.dir = this.filters.dir || this.dir;
      this.sourceRoot(path.join(__dirname, './templates/'));
      this.filters.templateDir = this.filters.dir.replace('src/client/', '');
      this.destinationRoot(path.join(process.cwd(), this.filters.dir));
      genUtils.write(this, this.filters);
    }
  });

}).call(this);
