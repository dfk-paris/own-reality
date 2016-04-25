<or-chronology>
  <div class="chronology">
    
  </div>

  <style type="text/scss">
    @import 'tmp/vis';
  </style>

  <script type="text/coffee">
    self = this
    self.mixin(window.or)

    self.retrieve = ->
      $.ajax(
        type: 'POST'
        url: "#{self.config.api_url}/api/chronology"
        data: {per_page: 2000}
        dataType: 'json'
        success: (data) ->
          self.items = []
          self.lookup = {}

          for o in data["records"]
            item = {
              "id": o._source.id
              "start": o._source.from_date
              # "end": o._source.to_date
              "content": self.filters.limitTo(o._source.title[self.locale()] || "Noname", 30)
              "title": o._source.title[self.locale()] || "Noname"
            }
            if item.start == item.end
              delete item.end

            if item.start
              self.lookup[item.id] = o
              self.items.push item

          self.widget.setItems self.items


      )

    self.on 'mount', ->
      element = $(self.root).find('div.chronology')[0]
      self.widget = new vis.Timeline(element, [],
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

      self.widget.on "select", (properties) ->
        if properties.items.length > 0
          self.bus.trigger 'chrono-select', self.lookup[properties.items[0]]

      self.retrieve()

  </script>
</or-chronology>