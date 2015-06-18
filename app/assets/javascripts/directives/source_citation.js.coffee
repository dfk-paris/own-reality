app.directive "orSourceCitation", [
  "templates_service",
  (ts) ->
    directive = {
      replace: true
      template: -> ts.fetch "source-citation"
      link: (scope, element) ->
        scope.locale = "de"
    }
]