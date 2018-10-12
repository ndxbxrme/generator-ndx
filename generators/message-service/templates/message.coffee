'use strict'

angular.module '<%= settings.appName %>'
.factory 'message', ->
  messages =<% if(settings.Menu) { %>
    #menu
    "menu-dashboard": 'Dashboard'<% if(settings.makeRoutesForEndpoints) { for(var f=0; f<settings.myEndpoints.length; f++) { %>
    "menu-<%= settings.myEndpoints[f].plural %>": '<%= settings.myEndpoints[f].plural %>'<% } } } %><% if(settings.FormExtras) { %>
    #forms
    "forms-cancel": 'Cancel'
    "forms-submit": 'Submit'<% } %><% if(settings.makeRoutesForEndpoints) { for(var f=0; f<settings.myEndpoints.length; f++) { %>
    #<%= settings.myEndpoints[f].single %>
    "<%= settings.myEndpoints[f].single %>-heading": '<%= settings.myEndpoints[f].single %>'
    "<%= settings.myEndpoints[f].single %>-name-label": 'Name'
    #<%= settings.myEndpoints[f].plural %>
    "<%= settings.myEndpoints[f].plural %>-heading": '<%= settings.myEndpoints[f].plural %>'
    "<%= settings.myEndpoints[f].plural %>-button-new": 'New <%= settings.myEndpoints[f].single %>'<% } } %>
    
  fillTemplate = (template, data) -> 
    template.replace /\{\{(.+?)\}\}/g, (all, match) ->
      evalInContext = (str, context) ->
        (new Function("with(this) {return #{str}}"))
        .call context
      evalInContext match, data
  m = (key, obj) ->
    if messages[key]
      return if obj then fillTemplate(messages[key], obj) else messages[key]
    if /-placeholder$/.test key
      key = key.replace 'placeholder', 'label'
      if messages[key]
        return if obj then fillTemplate(messages[key], obj) else messages[key]
    console.log 'missing message:', key
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m