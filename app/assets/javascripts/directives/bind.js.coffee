app.directive "orBind", [
  ->
    directive = {
      scope: {
        data: "=orBind"
      }
      link: (scope, element) ->
        scope.$watch "data", (new_value) ->
          element.html(new_value)
    }
]