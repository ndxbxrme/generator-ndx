module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  grunt.initConfig
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee']
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
  grunt.registerTask 'default', [
    'coffee'
    'watch'
  ]