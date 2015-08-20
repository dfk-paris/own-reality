app.directive "orKeywordList", [
  "data_service", "session_service", "templates_service", "$filter",
  (ds, ss, ts, filter) ->
    directive = {
      restrict: "A"
      template: -> ts.fetch "or-keyword-list"
      replace: true
      scope: {
        ids: "=orKeywordList"
      }
      link: (scope, element, attrs) ->
        scope.locale = -> ss.locale

        update = -> 
          if scope.ids && scope.ids.length > 0
            ds.lookup(scope.ids).success (data) ->
              console.log data
              scope.view = (k._source.name[scope.locale()] for k in data)
              scope.view.sort (x, y) ->
                return -1 if x < y
                return 0 if x == y
                return 1
              scope.view = filter("unique")(scope.view)

        scope.$watchCollection "ids", update
        scope.$watch "locale()", update
    }
]