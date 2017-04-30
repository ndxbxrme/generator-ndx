```bash
yo ndx:invited
```

```coffeescript
  $scope.inviteUser = ->
    $scope.newUser.roles = {}
    $scope.newUser.roles[$scope.newUser.role] = {}
    delete $scope.newUser.role
    $http.post '/api/get-invite-code', $scope.newUser
    .then (response) ->
      $scope.inviteUrl = response.data
    , (err) ->
      $scope.inviteError = err.data
    $scope.newUser =
      role: 'agency'
  $scope.copyInviteToClipboard = ->
    $('.invite-url input').select()
```

```jade
  .invite-user
    h3 Invite user
    form(name='addUserForm', ng-submit='inviteUser()')
      .row
        input(type='email', ng-model='newUser.local.email', placeholder='Email address')
        select(ng-model='newUser.role')
          option(value='agency', selected) Agency
          option(value='admin') Admin
      input(type='submit', value='Invite')
    .invite-error {{inviteError}}
    .invite-url(ng-show='inviteUrl')
      p An email has been sent or you can copy and paste the url below
      .row
        input(type='text', ng-model='inviteUrl')
        button(ng-click='copyInviteToClipboard()') Copy
```
