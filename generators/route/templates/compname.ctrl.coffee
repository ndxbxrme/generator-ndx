'use strict'

angular.module '<%= appName %>'
.controller '<%= compnameCapped%>Ctrl', ($scope<% if(parameters){ %>, $stateParams<% } %>) ->
  true