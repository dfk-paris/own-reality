app.directive "orKeywordList", [
  "attributes_service", "session_service", "templates_service", "$filter",
  (as, ss, ts, filter) ->
    directive = {
      restrict: "A"
      template: -> ts.fetch "or-keyword-list"
      replace: true
      scope: {
        ids: "=orKeywordList"
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

          id_list = []

          if scope.ids
            for klass_id, kinds of scope.ids
              for kind_id, attrib_ids of kinds
                key = "#{klass_id}.#{kind_id}"
                if (only.length == 0 || (only.indexOf(key) > -1)) && except.indexOf(key) == -1
                  id_list = id_list.concat(attrib_ids)

          if id_list && id_list.length > 0
            as.index(id_list).success (data) ->
              scope.view = (k._source.name[scope.locale()] for k in data)
              scope.view.sort()
              scope.view = filter("unique")(scope.view)

        scope.$watchCollection "ids", update
        scope.$watch "locale()", update
    }
]