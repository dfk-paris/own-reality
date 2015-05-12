app.controller "root_controller", [
  "$scope", "data_service", "session_service",
  (scope, ds, ss) ->
    scope.form = {
      lower: 1961
      upper: 1980
      refs: []
    }

    scope.ds = -> ds
    # scope.random = (n) -> Math.floor(Math.random() * n)

    scope.locales = ss.locales
    scope.locale = "de"

    query = (new_form = {}) ->
      ds.search(new_form).success (search_data) ->
        console.log(search_data)
        ds.lookup_for(search_data).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup
          scope.data = search_data
      
    scope.$watch "form", query, true
    scope.$watch "locale", (new_value) -> ss.locale = new_value

    # scope.set_locale = (locale) -> ss.locale = locale

    scope.add_ref = (key, event) ->
      event.preventDefault()
      scope.form.refs.push(key)

    scope.remove_ref = (key, event) ->
      event.preventDefault()
      i = scope.form.refs.indexOf(key)
      scope.form.refs.splice i, 1

    window.s = scope
]