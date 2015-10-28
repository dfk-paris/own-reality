app.controller "paper_controller", [
  "$scope", "papers_service", "$stateParams", "session_service",
  (scope, ps, sp, ss) ->
    ps.show(sp.type, sp.id).success (data) -> 
      scope.object = data

    scope.debug = -> ss.debug
]