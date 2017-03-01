(function() {
  'use strict';
  var fs, glob, launchGrunt, spawn, spawnSync, write;

  spawn = require('cross-spawn');

  glob = require('glob');

  fs = require('fs');

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
    return files = glob('**', {
      dot: true,
      cwd: yeoman.sourceRoot()
    }, function(err, files) {
      var f, i, len;
      for (i = 0, len = files.length; i < len; i++) {
        f = files[i];
        if (fs.lstatSync(yeoman.templatePath(f)).isDirectory()) {
          fs.mkdirSync(yeoman.destinationPath(f));
        }
        yeoman.fs.copyTpl(yeoman.templatePath(f), yeoman.destinationPath(f.replace('compname', yeoman.compname)), options);
      }
      return typeof cb === "function" ? cb() : void 0;
    });
  };

  launchGrunt = function(yeoman) {
    yeoman.log('');
    yeoman.log('Your app has been built');
    yeoman.log('CD into ' + yeoman.filters.appName + '/');
    yeoman.log('and type');
    yeoman.log('    grunt');
    yeoman.log('to run');
    yeoman.log('');
    return yeoman.spawnCommand('grunt', null, null);
  };

  module.exports = {
    spawnSync: spawnSync,
    write: write,
    launchGrunt: launchGrunt
  };

}).call(this);
