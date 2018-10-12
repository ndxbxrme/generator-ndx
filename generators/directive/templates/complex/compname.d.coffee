'use strict'

angular.module '<%= settings.appName %>'
.directive '<%= compnameCamel %>', ->
  restrict: 'EA'
  templateUrl: '<%= templateDir %>/<%= compname %>.html'
  replace: true
  link: (scope, elem, attrs) ->
    console.log '<%= compname %> directive'