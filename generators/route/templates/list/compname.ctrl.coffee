'use strict'

angular.module '<%= settings.appName %>'
.controller '<%= compnameCapped%>Ctrl', ($scope<% if(parameters){ %>, $stateParams<% } %><% if(settings.Sorting){ %>, Sorter<% } %>) ->
  $scope.<%= endpointPlural %> = $scope.list '<%= endpoint %>'<% if(settings.Pagination) {%>,
    page: 1
    pageSize: 10<% } %><% if(settings.Sorting) { %>
  $scope.<%= endpointPlural %>.sort = Sorter.create $scope.<%= endpointPlural %>.args<% } %>