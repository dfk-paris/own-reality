app.controller "chronology_controller", [
  "$scope", "chronology_service", "session_service", "data_service",
  (scope, cs, ss, ds) ->
    cs.index().success (data) ->
      scope.items = data


    scope.$watch "current", ->
      if scope.current
        ds.lookup_for(scope.current._source).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup

    scope.locale = -> ss.locale
    scope.debug = -> ss.debug
]