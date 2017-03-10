tmpH = "Home (<a href='#/first'>first</a> | <a href='#/second'>second</a>)"
tmpF = "First (<a href=''>home</a> | <a href='#/second'>second</a>)"
tmpS = "Second (<a href=''>home</a> | <a href='#/first'>first</a>)"

@testApp.config ['$routeProvider', ($routeProvider)->
  $routeProvider
    .when('/',       {template: tmpH})
    .when('/first',  {template: tmpF})
    .when('/second', {templateUrl: @templateUrl})
    .otherwise({redirectTo: '/'})
]