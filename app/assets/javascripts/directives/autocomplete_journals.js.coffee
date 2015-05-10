app.directive "orAutocompleteJournals", [
  "data_service"
  (ds) ->
    directive = {
      restrict: "EAC"
      link: (scope, element, attrs) ->
        element.autocomplete(
          source: ds.journals
          minLength: 2
          delay: 100
        )
    }
]