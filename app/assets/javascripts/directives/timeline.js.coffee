app.directive "orTimeline", [
  "session_service", "$filter",
  (ss, filter) ->
    directive = {
      restrict: "A"
      scope: {
        data: "=*orTimeline"
        current: "=orCurrent"
      }
      link: (scope, element, attrs) ->
        limitTo = filter("limitTo")
        scope.locale = -> ss.locale

        lookup = {}
        
        timeline = new vis.Timeline(element[0], [],
          min: "1960"
          max: "1990"
          start: "1960-01"
          end: "1960-07"
          # end: "1990"
          zoomable: false
          # stack: false
          minHeight: "600px"
          maxHeight: "600px"
          dataAttributes: ["id"]
        )

        timeline.on "select", (properties) ->
          item = lookup[properties.items[0]]
          scope.current = item
          scope.$apply()
          console.log(item)

        update_from_data = ->
          new_data = []
          lookup = {}

          for o in scope.data["records"]
            item = {
              "id": o._source.id
              "start": o._source.from_date
              # "end": o._source.to_date
              "content": limitTo(o._source.title[ss.locale] || "Noname", 30)
              "title": o._source.title[ss.locale] || "Noname"
            }
            if item.start == item.end
              delete item.end

            if item.start
              lookup[item.id] = o
              new_data.push item

          timeline.setItems new_data

        scope.$watchCollection "data", ->
          if scope.data
            update_from_data()

        scope.$watch "locale()", ->
          if scope.data
            update_from_data()
    }
]