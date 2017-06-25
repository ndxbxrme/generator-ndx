(function() {
  var _, fs, genUtils, path, yeoman;

  yeoman = require('yeoman-generator');

  fs = require('fs');

  path = require('path');

  genUtils = require('../util');

  _ = require('underscore.string');

  module.exports = yeoman.generators.Base.extend({
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
    write: function() {
      this.filters.dir = '';
      this.sourceRoot(path.join(__dirname, './templates/'));
      this.filters.templateDir = this.filters.dir.replace('src/client/', '');
      this.destinationRoot(path.join(process.cwd(), this.filters.dir));
      genUtils.write(this, this.filters);
    }
  });

}).call(this);
