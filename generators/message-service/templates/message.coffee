'use strict'

angular.module '<%= appName %>'
.factory 'message', ->
  messages =
    #general
    example: 'Message'
    
  m = (key) ->
    if messages[key]
      return messages[key]
    if key.indexOf('placeholder') is 0
      key = key.replace 'placeholder', 'title'
      if messages[key]
        return messages[key]
    #console.log key
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m