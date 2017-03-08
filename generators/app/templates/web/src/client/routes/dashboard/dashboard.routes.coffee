'use strict'

angular.module '<%= appName %>'
.config ($stateProvider) ->
  $stateProvider
  .state 'dashboard',
    url: '/'
    templateUrl: 'routes/dashboard/dashboard.html'
    controller: 'DashboardCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise()