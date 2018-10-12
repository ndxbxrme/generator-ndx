'use strict'

angular.module '<%= settings.appName %>'
.controller '<%= compnameCapped%>Ctrl', ($scope<% if(parameters){ %>, $stateParams<% } %>) ->
  $scope.<%= endpointSingle %> = $scope.single '<%= endpoint %>', $stateParams