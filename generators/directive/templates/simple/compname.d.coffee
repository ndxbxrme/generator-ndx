'use strict'

angular.module '<%= settings.appName %>'
.directive '<%= compname %>', ->
  restrict: 'EA'
  link: (scope, elem, attrs) ->
    console.log '<%= compname %> directive'