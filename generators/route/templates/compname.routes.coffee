'use strict'

angular.module '<%= appName %>'
.config ($stateProvider) ->
  $stateProvider.state '<%= compnameSlugged %>',
    url: '/<%= compnameSlugged %><% if(parameters){ %>/<%=parameters%><% } %>'
    templateUrl: '<%= templateDir %>/<%=compnameSlugged%>.html'
    controller: '<%= compnameCapped %>Ctrl'
    resolve:
      user: (Auth) ->
        Auth.getPromise(<%= roles %>)