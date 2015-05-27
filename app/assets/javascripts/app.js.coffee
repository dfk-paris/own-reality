app.config [
  "$routeProvider",
  (rp) ->

    rp.when "/query", templateUrl: "/query", reloadOnSearch: false
    rp.otherwise "/query"
    
]