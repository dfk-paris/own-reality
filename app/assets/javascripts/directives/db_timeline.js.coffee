app.directive "orDbTimeline", [
  "session_service", "$filter", "chronology_service",
  (ss, filter, cs) ->
    directive = {
      restrict: "A"
      scope: {
        # from: "=orFrom"
        # to: "=orTo"
        # category_id: "=orCategoryId"
        form: "=orForm"
        aggregations: "=orAggregations"
        excess: "=orExcess"
        total: "=orTotal"
      }
      link: (scope, element, attrs) ->
        limitTo = filter("limitTo")
        scope.locale = -> ss.locale

        lookup = {}

        groups = [
          {id: 57, content: "", className: "or-chrono-group-57", position: 1}, #Reise
          {id: 58, content: "", className: "or-chrono-group-58", position: 2}, #Ereignis
          {id: 59, content: "", className: "or-chrono-group-60", position: 4}, #Veröffentlichung
          {id: 60, content: "", className: "or-chrono-group-59", position: 3}, #Ausstellung
          {id: 999, content: "", className: "or-chrono-group-999", position: 5},
          # {id: 57, content: "", className: "or-chrono-group-57"},
          # {id: 58, content: "", className: "or-chrono-group-58"},
          # {id: 60, content: "", className: "or-chrono-group-59"},
          # {id: 59, content: "", className: "or-chrono-group-60"}
        ]
        
        timeline = new vis.Timeline(element[0], [], groups,
          min: "1960"
          max: "1990"
          start: "1959-12"
          end: "1960-07"
          # end: "1990"
          zoomable: true
          stack: false
          # minHeight: "210px"
          height: "210px"
          # maxHeight: "200px"
          dataAttributes: ["id"]
          type: "point"
          align: "center"
          # showMajorLabels: false
          groupOrder: (x, y) ->
            return -1 if x.position < y.position
            return 1 if x.position > y.position
            return 0
        )

        group_for = (item) ->
          try
            item._source.attrs.ids[4][2][0]
          catch
            undefined

        update = ->
          # if scope.form.upper - scope.form.lower > 5
          #   return

          cs.index(scope.form).success (data) ->
            scope.total = data.total
            if data.total <= (scope.form.chrono_per_page || 100)
              scope.excess = false
              update_timeline(data)
            else
              scope.excess = true

          update_timeline = (data) ->
            timeline.setOptions(
              min: "#{scope.form.lower - 1}-12"
              max: "#{scope.form.upper}-02"
              start: "#{scope.form.lower - 1}-12"
              end: "#{scope.form.upper}-02"
            )

            new_data = []
            lookup = {}

            for o in data["records"]
              item = {
                "id": o._source.id
                "start": o._source.from_date
                # "end": o._source.to_date
                # "content": "#{group_for(o)}"
                "group": group_for(o)
                # "title": o._source.title[ss.locale] || "Noname"
              }

              if item.start
                lookup[item.id] = o
                new_data.push item

            console.log(new_data)

            timeline.setItems new_data
            scope.aggregations = data.aggregations['attr.4.2'].buckets


        scope.$watch "form", update, true
        # scope.$watch "from", update
        # scope.$watch "to", update
        # scope.$watch "category_id", update
    }
]