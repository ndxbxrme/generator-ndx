'use strict'

angular.module '<%= appName %>', [
  'ndx'
  'ui.router'
]
.run ($rootScope, $state) ->
  $rootScope.$on '$stateChangeStart', ->
    if $state.current.name
      $('body').removeClass "#{$state.current.name}-page"
  $rootScope.$on '$stateChangeSuccess', ->
    if $state.current.name
      $('body').addClass "#{$state.current.name}-page"
    $('html, body').animate
      scrollTop: 0
    , 200
.config ($locationProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true
angular.module 'ndx', [] #ndx module stub