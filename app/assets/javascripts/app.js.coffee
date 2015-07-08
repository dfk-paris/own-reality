app.config [
  "$routeProvider",
  (rp) ->

    rp.when "/query", templateUrl: "/query", reloadOnSearch: false
    rp.when "/synthese/:id", templateUrl: "/synthese", reloadOnSearch: false
    rp.otherwise "/query"
    
]