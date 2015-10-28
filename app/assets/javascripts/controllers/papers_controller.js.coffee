app.controller "papers_controller", [
  "$scope", "papers_service", "session_service", "$stateParams",
  (scope, ps, ss, sp) ->
    ps.index(sp.type).success (data) -> 
      scope.objects = data

    scope.locale = -> ss.locale
    scope.debug = -> ss.debug
]