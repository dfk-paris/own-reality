app.controller "paper_controller", [
  "$scope", "papers_service", "$routeParams", "session_service",
  (scope, ps, rp, ss) ->
    ps.show(rp.type, rp.id).success (data) -> 
      scope.object = data
      console.log data

    scope.debug = -> ss.debug
]