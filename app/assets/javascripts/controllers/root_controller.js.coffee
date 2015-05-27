app.controller "root_controller", [
  "$scope", "data_service", "session_service", "wuBase64Location",
  (scope, ds, ss, l) ->
    scope.form = l.search("form") || {
      lower: 1961
      upper: 1980
      refs: []
    }

    scope.locales = ds.locales
    scope.locale = ss.locale

    scope.$on "$routeChangeSuccess", -> query()
    scope.$on "$routeUpdate", ->
      console.log("querying", scope.form)
      query()

    query = ->
      ds.search(scope.form).success (search_data) ->
        console.log(search_data)
        ds.lookup_for(search_data, scope.form).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup
          scope.results = search_data

    urlUpdate = ->
      l.search "form", scope.form
      
    scope.$watch "form", urlUpdate, true
    scope.$watch "locale", (new_value) -> ss.locale = new_value

    scope.add_ref = (key, event) ->
      event.preventDefault()
      scope.form.refs.push(key)

    scope.remove_ref = (key, event) ->
      event.preventDefault()
      i = scope.form.refs.indexOf(key)
      scope.form.refs.splice i, 1

    window.l = l
    window.s = scope
]