'use strict'

angular.module '<%= settings.appName %>'
.directive 'header', ->
  restrict: 'EA'
  templateUrl: 'directives/header/header.html'
  replace: true