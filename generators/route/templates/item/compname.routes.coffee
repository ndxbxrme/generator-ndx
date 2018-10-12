'use strict'

angular.module '<%= settings.appName %>'
.config ($stateProvider) ->
  $stateProvider.state '<%= compnameSlugged %>',
    url: '/<%= compnameSlugged %><% if(parameters){ %>/<%=parameters%><% } %>'
    templateUrl: '<%= templateDir %>/<%=compnameSlugged%>.html'
    controller: '<%= compnameCapped %>Ctrl'
    data:
      title: '<%= title %>'
      auth: <%= roles %>