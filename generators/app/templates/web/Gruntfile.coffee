module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  serveStatic = require 'serve-static'
  grunt.initConfig
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee']
      jade:
        files: ["src/**/*.jade"]
        tasks: ['jade', 'wiredep', 'injector']
      stylus:
        files: ["src/**/*.stylus"]
        tasks: ['stylus']
      livereload:
        options:
          livereload: '8025'
        files: [
          'build/**/*.html'
          'build/**/*.css'
          'build/**/*.js'
        ]
    connect:
      options:
        port: 8023
        hostname: '0.0.0.0'
        livereload: 8025
      livereload:
        options:
          open: true
          middleware: (connect) ->
            [
              serveStatic('build/client')
              connect().use('/build', serveStatic('./build'))
              connect().use('/src', serveStatic('./src'))
              connect().use('/client/bower_components', serveStatic('./client/bower_components'))
            ]
    coffee:
      options:
        sourceMap: true
      default:
        files: [{
          expand: true
          cwd: 'src'
          src: ['**/*.coffee']
          dest: 'build'
          ext: '.js'
        }]
    jade:
      default:
        files: [{
          expand: true
          cwd: 'src'
          src: ['**/*.jade']
          dest: 'build'
          ext: '.html'
        }]
    injector:
      default:
        files:
          "build/index.html": ['build/**/*.js', 'build/**/*.css']
    stylus:
      default:
        files:
          "build/app.css": "src/**/*.stylus"
    wiredep:
      options:
        directory: 'build/bower'
      target:
        src: 'build/index.html'
  grunt.registerTask 'default', [
    'coffee'
    'jade'
    'stylus'
    'wiredep'
    'injector'
    'connect:livereload'
    'watch'
  ]