'use strict'

angular.module '<%= appName %>'
.directive '<%= compname %>', ->
  restrict: 'EA'
  link: (scope, elem, attrs) ->
    console.log '<%= compname %> directive'