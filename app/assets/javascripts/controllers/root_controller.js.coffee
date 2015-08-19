app.controller "root_controller", [
  "$scope", "session_service", "data_service",
  (scope, ss, ds) ->
    scope.config = {
      locales: ds.locales
      locale: ss.locale
    }

    scope.$watch "config.locale", (new_value) -> 
      ss.locale = new_value

    scope.shortcut = (event) ->
      if event.ctrlKey && event.altKey
        if event.which == 68
          ss.debug = !ss.debug

    scope.debug = -> ss.debug
      
]