'use strict'

angular.module '<%= settings.appName %>', [
  'ndx'
  'ui.router'<% if(settings.FileUpload) { %>
  'ngFileUpload'<% } %>
]
.config ($locationProvider, $urlRouterProvider<% if(settings.anonymousUser) { %>, AuthProvider<% } %>) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true<% if(settings.anonymousUser) { %>
  AuthProvider.config
    anonymousUser: true<% } %><% if(settings.FileUpload) { %>
.run ($rootScope) ->
  $rootScope.makeDownloadUrl = (document) ->
    if document
      '/api/download/' + btoa JSON.stringify({path:document.path,filename:document.originalFilename})<% } %>
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub