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
    firstThing: function() {
      var cb;
      cb = this.async();
      console.log('I\'m doin it');
      return cb();
    }
  });

}).call(this);
