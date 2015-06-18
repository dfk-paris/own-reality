app.directive "orSourceDialog", [
  "templates_service", "data_service", "session_service",
  (ts, ds, ss) ->
    directive = {
      scope: {
        "id": "=orSourceDialog"
      }
      template: ts.fetch "source-dialog"
      replace: "element"
      link: (scope, element) ->
        scope.misc = -> ds.misc

        scope.$watch "id", ->
          console.log scope.misc()
          console.log ss
          if scope.id
            ds.show(scope.id).success (data) -> 
              scope.object = data

    }
]