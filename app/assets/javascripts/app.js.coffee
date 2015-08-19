app.config [
  "$routeProvider",
  (rp) ->

    rp.when "/home", templateUrl: "/home", reloadOnSearch: false
    rp.when "/chronology", templateUrl: "/chronology", reloadOnSearch: false
    rp.when "/query", templateUrl: "/query", reloadOnSearch: false
    rp.when "/papers/:type", templateUrl: ((rp) -> "/papers/#{rp.type}"), reloadOnSearch: false
    rp.when "/papers/:type/:id", templateUrl: "/paper", reloadOnSearch: false
    rp.otherwise "/home"
    
]