'use strict'

angular.module '<%= settings.appName %>'
.directive 'footer', ->
  restrict: 'EA'
  templateUrl: 'directives/footer/footer.html'
  replace: true