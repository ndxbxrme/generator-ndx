'use strict'

angular.module '<%= appName %>'
.config ($stateProvider) ->
  $stateProvider.state 'invited',
    url: '/invited'
    templateUrl: '<%= templateDir %>/invited.html'
    controller: 'InvitedCtrl'