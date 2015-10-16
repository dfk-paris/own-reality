app.directive "orPeopleList", [
  "session_service", "templates_service", "$filter",
  (ss, ts, filter) ->
    directive = {
      restrict: "A"
      template: -> ts.fetch "or-people-list"
      replace: true
      scope: {
        ids: "=orPeopleList"
        only: "@orOnly"
        except: "@orExcept"
      }
      link: (scope, element, attrs) ->
        scope.locale = -> ss.locale
        scope.only ||= ""
        scope.except ||= ""

        update = -> 
          only = scope.only.split(/\s*,\s*/)
          except = scope.except.split(/\s*,\s*/)
          only = [] if only[0] == ""
          except = [] if except[0] == ""

          scope.view = []

          if scope.ids
            for role_id, people of scope.ids
              key = "#{role_id}"
              if (only.length == 0 || (only.indexOf(key) > -1)) && except.indexOf(key) == -1
                scope.view = scope.view.concat(people)

          console.log(scope.view)

        scope.$watchCollection "ids", update
        scope.$watch "locale()", update
    }
]