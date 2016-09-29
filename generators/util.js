(function() {
  'use strict';
  var fs, glob, path, spawn, spawnSync, write;

  path = require('path');

  fs = require('fs');

  spawn = require('cross-spawn');

  glob = require('glob');

  spawnSync = function(command, args, cb) {
    var poll, result;
    result = spawn(command, args, {
      stdio: 'inherit'
    });
    poll = function() {
      if (result._closesGot === 1) {
        if (typeof cb === "function") {
          cb();
        }
      } else {
        setTimeout(poll, 500);
      }
    };
    poll();
  };

  write = function(yeoman, options, cb) {
    var files;
    if (!self.filters.jade) {
      self.filters.jade = false;
    }
    return files = glob('**', {
      dot: true,
      cwd: self.sourceRoot()
    }, function(err, files) {
      var f, i, len;
      for (i = 0, len = files.length; i < len; i++) {
        f = files[i];
        yeoman.fs.copyTpl(self.templatePath(f), self.destinationPath(f), options);
      }
      return typeof cb === "function" ? cb() : void 0;
    });
  };

  module.exports = {
    spawnSync: spawnSync,
    write: write
  };

}).call(this);
