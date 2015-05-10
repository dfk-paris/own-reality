app.directive "orSlider", [
  ->
    directive = {
      restrict: "EAC"
      scope: {
        "lower": "=orSliderLower"
        "upper": "=orSliderUpper"
      }
      link: (scope, element, attrs) ->
        element.slider(
          range: true
          min: 1960
          max: 1989
          values: [scope.lower, scope.upper]
          slide: (event, ui) ->
            scope.lower = ui.values[0]
            scope.upper = ui.values[1]
            scope.$apply()
        )
    }
]