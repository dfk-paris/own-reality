app.directive "orBindTranslate", [
  "data_service", "session_service", "templates_service", "orTranslate",
  (ds, ss, ts, ot) ->
    directive = {
      scope: {
        "data": "=orBindTranslate"
        "key": "@orBindTranslate"
        "options": "=orTranslateOptions"
      }
      template: ts.fetch "translated-text"
      replace: false
      link: (scope, element) ->
        update = -> 
          scope.fallback = false
          scope.message = null
          scope.translation = null

          if scope.data
            if scope.data[ss.locale]
              scope.translation = scope.data[ss.locale]
            else
              for c, n of ds.locales
                if scope.data[c]
                  scope.fallback = ds.locales[c]

                  scope.message = if ss.locale == "de"
                    "Dieser Text ist nicht auf deutsch verfügbar"
                  else if ss.locale == "fr"
                    "Ce texte n'est pas disponible en français"
                  else
                    ""

                  scope.translation = scope.data[c]
                  return scope.data[c]


        scope.current_locale = -> ss.locale

        scope.$watch "data", update, true
        scope.$watch "current_locale()", update, true
    }
]