# static data - for testing
@testApp.factory 'Addr', ->
  Addr = {}
  Addr.banned =
    [
      {address: "asfd@xyz.com"}
      {address: "qwer@xyz.com"}
      {address: "zxcv@xyz.com"}
    ]
  Addr

# for rails CSRF
@testApp.config ["$httpProvider", ($httpProvider) ->
  token = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = token
]

# this datasource uses JSON
@testApp.factory 'Addr2', ($resource)->
  $resource("/ajax/banned_emails/:id", {id: "@id"}, {update: {method: "PUT"}} )

@testApp.controller 'AddressController', ($scope, Addr2)->
  $scope.addr = Addr2.query()                     # ajax-based data-source
  $scope.addEntryOld = ->                         # old method using static data
    $scope.addr.banned.push($scope.newEntry)
    $scope.newEntry = {}
  $scope.addEntry = ->                            # this method uses ajax
    entry = Addr2.save($scope.newEntry)
    $scope.addr.push(entry)
    $scope.newEntry = {}
  $scope.delEntry = (idx)->
    deleted = $scope.addr[idx]
    console.log "DELETING", idx, deleted
    $scope.addr.splice(idx, 1)
    deleted.$delete()
  $scope.updateEntry = (idx)->
    updated = $scope.addr[idx]
    console.log "UPDATE ENTRY", idx, $scope
    updated.$update()

@testApp.controller 'ChildController', ($scope)->
  $scope.updateChild = (idx) ->
    console.log "UPDATE NOW", idx, $scope.$parent
    $scope.viz.editing = false
    $scope.$parent.updateEntry(idx)


