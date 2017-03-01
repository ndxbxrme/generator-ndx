'use strict'

angular.module '<%= appName %>'
.config ($stateProvider, $locationProvider, $urlRouterProvider) ->
  $stateProvider
  .state 'dashboard',
    url: '/'
    templateUrl: 'routes/dashboard/dashboard.html'
    controller: 'DashboardCtrl'
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true