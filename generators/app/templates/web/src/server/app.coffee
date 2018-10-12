'use strict'

require 'ndx-server'
.config<% if(settings.dbType==='Ndxdb') {%>
  database: 'db'<% } if(settings.dbType==='Mongo') { %>
  dbEngine: require 'ndx-mongo'<% } %>
  tables: ['<%= settings.userTable %>'<% var tables = settings.dbTables.split(/,/g); for(var f=0; f<tables.length; f++) { if(tables[f].trim()) {%>, '<%= tables[f].trim() %>'<% }} %>]<% if(settings.dbType==='Ndxdb') {%>
  localStorage: './data'<% } %><% if(settings.userTable!=='users') {%>
  userTable: '<%= settings.userTable %>'<% } %><% if(settings.anonymousUser) { %>
  anonymousUser: true<% } %>
.start()
