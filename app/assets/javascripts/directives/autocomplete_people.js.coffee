app.directive "orAutocompletePeople", [
  "data_service",
  (ds) ->
    directive = {
      restrict: "EAC"
      link: (scope, element, attrs) ->
        element.autocomplete(
          source: ds.people
          minLength: 2
          delay: 100
        )
    }
]