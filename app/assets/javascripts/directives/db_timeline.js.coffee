app.directive "orDbTimeline", [
  "session_service", "$filter", "chronology_service", "templates_service",
  (ss, filter, cs, ts) ->
    directive = {
      restrict: "A"
      template: -> ts.fetch("or-db-timeline")
      replace: true
      scope: {
        # from: "=orFrom"
        # to: "=orTo"
        # category_id: "=orCategoryId"
        listing: "=orDbTimeline"
        # filters: "=orFilters"
        aggregations: "=orAggregations"
      }
      link: (scope, element, attrs) ->
        scope.locale = -> ss.locale

        widget = $(element).find(".or-widget")[0]

        scope.listing.chrono ||= {}
        scope.listing.filters.chrono ||= {
          per_page: 100
        }

        # lookup = {}

        timeline = new vis.Timeline(widget, [], undefined,
          min: "1960"
          max: "1990"
          start: "1959-12"
          end: "1960-07"
          # end: "1990"
          zoomable: true
          stack: false
          # minHeight: "210px"
          height: "120px"
          # maxHeight: "200px"
          dataAttributes: ["id"]
          type: "point"
          align: "center"
          selectable: false
          # template: (item) ->
          #   console.log item
          #   "<div class='vis-dot' data-title='#{item.id}'></div>"
          # showMajorLabels: false
          # groupOrder: (x, y) ->
          #   return -1 if x.position < y.position
          #   return 1 if x.position > y.position
          #   return 0
        )

        # pops = []
        # $("body").on "click", -> 
        #   # for pop in pops
        #     # pop.popover("destroy")
        #   pops = []

        # element.popover(
        #   content: "content"
        #   placement: "bottom"
        #   trigger: "hover"
        #   container: "body"
        #   selector: ".vis-item-content .vis-dot"
        # )

        # element.on "click", ".dvis-dot", (event) ->
        #   e = $(event.target)
        #   id = e.parents(".vis-item").attr("data-id")
        #   # e.popover(
        #   #   title: id
        #   #   content: "content"
        #   #   placement: "top"
        #   #   trigger: "manual"
        #   #   container: "body"
        #   # )
        #   # e.popover("show")
        #   # pops.push e
        #   console.log id

        # timeline.on "click", (o) ->
        #   if o.item
        #     e = $(o.event.target)
        #     e.popover(
        #       title: "Title"
        #       content: "content"
        #       placement: "top"
        #       trigger: "manual"
        #       container: "body"
        #     )
        #     e.popover("toggle")
        #     console.log(o)
        #     console.log o.item

        # group_for = (item) ->
        #   try
        #     item._source.attrs.ids[4][2][0]
        #   catch
        #     undefined

        update = ->
          # if scope.form.upper - scope.form.lower > 5
          #   return

          chrono_params = angular.copy(scope.listing.filters)
          chrono_params.per_page = scope.listing.filters.chrono.per_page
          cs.index(chrono_params).success (data) ->
            console.log data
            scope.listing.chrono.total = data.total
            if data.total <= scope.listing.filters.chrono.per_page
              scope.listing.chrono.excess = false
              update_timeline(data)
            else
              scope.listing.chrono.excess = true

        update_timeline = (data) ->
          timeline.setOptions(
            min: "#{scope.listing.filters.lower - 1}-12"
            max: "#{scope.listing.filters.upper}-02"
            start: "#{scope.listing.filters.lower - 1}-12"
            end: "#{scope.listing.filters.upper}-02"
          )

          new_data = []
          # lookup = {}

          for o in data["records"]
            item = {
              "id": o._source.id
              "start": o._source.from_date
              # "end": o._source.to_date
              # "content": "#{group_for(o)}"
              # "group": group_for(o)
              data: {
                title: o._source.title[ss.locale] || "Noname" 
              }
              # "content": o._source.title[ss.locale] || "Noname"
            }

            if item.start
              # lookup[item.id] = o
              new_data.push item

          # console.log(new_data)

          timeline.setItems new_data
          scope.listing.chrono.aggregations = data.aggregations['attr.4.2'].buckets


        scope.$watch "listing.filters", update, true
        # scope.$watch "from", update
        # scope.$watch "to", update
        # scope.$watch "category_id", update
    }
]