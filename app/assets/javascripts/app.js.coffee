app.config [
  "$stateProvider", "$urlRouterProvider",
  (sp, urp) ->
    urp.otherwise "/home"

    sp.state("welcome",
      url: "/home"
      templateUrl: "/home"
    )

    sp.state("chronology",
      url: "/chronology"
      templateUrl: "/chronology"
    )

    sp.state("papers",
      url: "/papers/:type"
      templateUrl: ((sp) -> "/papers/#{sp.type}")
    )

    sp.state("paper_show",
      url: "/papers/:type/:id"
      templateUrl: "/paper"
    )

    sp.state("query",
      url: "/query?q"
      templateUrl: "/query"
      reloadOnSearch: false
    )    

]