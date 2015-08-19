app.controller "papers_controller", [
  "$scope", "papers_service", "session_service", "$routeParams",
  (scope, ps, ss, rp) ->
    ps.index(rp.type).success (data) -> 
      scope.objects = data
      console.log data

    scope.locale = -> ss.locale
    scope.debug = -> ss.debug
]