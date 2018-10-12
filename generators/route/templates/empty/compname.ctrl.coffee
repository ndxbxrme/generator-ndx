'use strict'

angular.module '<%= settings.appName %>'
.controller '<%= compnameCapped%>Ctrl', ($scope<% if(parameters){ %>, $stateParams<% } %>) ->
  true