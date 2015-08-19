app.directive "orSourceDialog", [
  "templates_service", "data_service", "session_service", "orTranslate", "papers_service",
  (ts, ds, ss, ot, ps) ->
    directive = {
      scope: {
        "id": "=orSourceDialog"
      }
      template: ts.fetch "source-dialog"
      replace: "element"
      link: (scope, element) ->
        scope.has_value = ot.has_value
        scope.misc = -> ds.misc

        scope.$watch "id", ->
          if scope.id
            ps.show("sources", scope.id).success (data) -> 
              scope.object = data
              console.log data

    }
]