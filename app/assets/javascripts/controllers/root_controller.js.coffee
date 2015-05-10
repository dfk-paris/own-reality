app.controller "root_controller", [
  "$scope", "data_service", "session_service",
  (scope, ds, ss) ->
    scope.ds = -> ds
    scope.random = (n) -> Math.floor(Math.random() * n)
    scope.lower = 1961
    scope.upper = 1980

    scope.locales = ss.locales
    scope.locale = "de"
    scope.$watch "locale", (new_value) -> ss.locale = new_value
    scope.$watch "terms", (new_value) ->
      ds.search(terms: scope.terms).success (search_data) ->
        ds.lookup_for(search_data).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup
          scope.data = search_data

    scope.set_locale = (locale) -> ss.locale = locale

    window.s = scope
]