'use strict'
path = require('path')
fs = require('fs')
spawn = require('cross-spawn')
glob = require('glob')

  
spawnSync = (command, args, cb) ->
  result = spawn(command, args, stdio: 'inherit')

  poll = ->
    if result._closesGot == 1
      cb?()
    else
      setTimeout poll, 500
    return

  poll()
  return

write = (yeoman, options, cb) ->
  if !self.filters.jade
    self.filters.jade = false
  files = glob '**',
    dot: true
    cwd: self.sourceRoot()
  , (err, files) ->
    for f in files
      yeoman.fs.copyTpl self.templatePath(f), self.destinationPath(f), options
    cb?()

module.exports =
  spawnSync: spawnSync
  write: write