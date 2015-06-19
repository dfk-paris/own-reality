app.directive "orSourceCitation", [
  "templates_service", "session_service",
  (ts, ss) ->
    directive = {
      scope: {
        "object": "=orSourceCitation"
      }
      replace: true
      template: -> ts.fetch "source-citation"
      link: (scope, element) ->
        scope.locale = -> ss.locale
    }
]