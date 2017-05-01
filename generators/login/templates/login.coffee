'use strict'

angular.module '<%= appName %>'
.directive 'login', ($http, $location) ->
  restrict: 'AE'
  templateUrl: '<%= templateDir %>/login.html'
  replace: true
  scope: {}
  link: (scope, elem) ->
    scope.login = ->
      scope.submitted = true
      if scope.loginForm.$valid
        $http.post '/api/login',
          email: scope.email
          password: scope.password
        .then (response) ->
          scope.auth.getPromise()
          .then ->
            $location.path '/loggedin'
        , (err) ->
          scope.message = err.data
          scope.submitted = false
    scope.signup = ->
      scope.submitted = true
      if scope.loginForm.$valid
        $http.post '/api/signup',
          email: scope.email
          password: scope.password
        .then (response) ->
          scope.auth.getPromise()
          .then ->
            $location.path '/loggedin'
        , (err) ->
          scope.message = err.data
          scope.submitted = false 