<or-filtered-chronology>
  
  <div>
    <div show={!excess()} class="or-timeline" />
    <div show={excess()} class="or-excess" style="display: none">
      TOO MANY ITEMS:
    </div>
    {data.total}
  </div>

  <style type="text/scss">
    or-filtered-chronology {
      .vis-dot {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.default_params = {
      per_page: 100
      lower: 1960
      upper: 1989
    }

    self.search = (params = self.default_params) ->
      self.params = params

      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/chronology"
        data: $.extend({}, self.default_params, params)
        success: (data) ->
          console.log data
          self.data = data
          self.new_data() unless self.excess()
      )

    self.new_data = ->
      console.log self.params
      self.timeline.setOptions(
        min: "#{self.params.lower - 1}-12"
        max: "#{self.params.upper}-02"
        start: "#{self.params.lower - 1}-12"
        end: "#{self.params.upper}-02"
      )

      new_data = []
      self.item_lookup = {}

      for o in self.data["records"]
        item = {
          id: o._source.id
          start: o._source.from_date
          title: o._source.title[self.or.config.locale] || "Noname" 
          # "end": o._source.to_date
          # "content": "#{group_for(o)}"
          # "group": group_for(o)
          # "content": o._source.title[ss.locale] || "Noname"
        }

        if item.start
          self.item_lookup[item.id] = o
          new_data.push item
        else
          console.log item

      # console.log(new_data)

      self.timeline.setItems new_data
      # scope.listing.chrono.aggregations = data.aggregations['attr.4.2'].buckets

      self.update()

    self.setup = ->
      $(self.root).find('.or-timeline').on 'click', '.vis-dot', (event) ->
        item = $(event.target).parents('.vis-point').data()

      self.timeline = new vis.Timeline(self.element()[0], [], undefined,
        min: "1960"
        max: "1990"
        start: "1959-12"
        # end: "1960-07"
        end: "1990"
        zoomable: true
        stack: false
        # minHeight: "210px"
        height: "120px"
        # maxHeight: "200px"
        dataAttributes: "all"
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

      item_click = (id) ->
        item = self.item_lookup[id]
        self.or.bus.trigger 'modal', 'or-chronology-detail', item: item
        console.log item


      self.timeline.on 'click', (props) ->
        item_click(props.item) if props.what == 'item'

    self.element = -> $(self.root).find('.or-timeline')
    self.excess = -> self.data.total > self.default_params.per_page
    self.on 'mount', ->
      self.setup()
    self.or.bus.on 'filter-change', (params) -> self.search(params)
  </script>

</or-filtered-chronology>