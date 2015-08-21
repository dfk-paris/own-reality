app.controller "chronology_controller", [
  "$scope", "chronology_service", "session_service", "attributes_service",
  (scope, cs, ss, as) ->
    cs.index().success (data) ->
      scope.items = data

    scope.$watch "current", ->
      if scope.current
        as.for(scope.current._source).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup

    scope.locale = -> ss.locale
    scope.debug = -> ss.debug
]