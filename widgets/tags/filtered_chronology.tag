<or-filtered-chronology>
  
  <div>
    <div show={!excess() && !trivial()} class="or-timeline" />
    <div class="edge">
      <div show={excess()} class="or-excess" style="display: none">
        {or.i18n.t('chronology')}:
        {or.i18n.t('too_much_data')} ({data.total})
        <div>
          <button>{or.i18n.t('show_all')}</button>
        </div>
      </div>
      <div show={trivial()}>
        {or.i18n.t('no_data')}
      </div>
    </div>
  </div>

  <style type="text/scss">
    @import "tmp/vis";

    or-filtered-chronology {
      display: block;
      margin-top: 1rem;
      margin-bottom: 1rem;

      .edge {
        font-size: 5rem;
        color: #bdbdbd;
        line-height: 6rem;

        .or-excess {
          text-align: center;

          & > div {
            font-size: 1rem;
            line-height: 1rem;
          }
        }
      }

      .vis-dot {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.default_params = {
      per_page: 100
    }

    self.params = ->
      return {
        per_page: self.default_params.per_page
        terms: self.or.routing.unpack()['terms']
        lower: self.or.routing.unpack()['lower'] || 1960
        upper: self.or.routing.unpack()['upper'] || 1989
        attribute_ids: self.or.routing.unpack()['attribs']
        people_ids: self.or.routing.unpack()['people']
      }

    self.search = ->
      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/chronology"
        data: self.params()
        success: (data) ->
          # console.log 'chrono data:', data
          self.data = data
          self.new_data(self.params()) unless self.excess() || self.trivial()
      )

    self.new_data = (params) ->
      # console.log 'chrono params:', params

      self.timeline.setOptions(
        min: "#{params.lower - 1}-12"
        max: "#{params.upper}-02"
        start: "#{params.lower - 1}-12"
        end: "#{params.upper}-02"
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
        # else
          # console.log item

      # console.log 'tl data:', new_data
      self.timeline.setItems new_data
      # scope.listing.chrono.aggregations = data.aggregations['attr.4.2'].buckets
      self.update()


    self.setup = ->
      # $(self.root).find('.or-timeline').on 'click', '.vis-dot', (event) ->
      #   item = $(event.target).parents('.vis-point').data()

      self.timeline = new vis.Timeline(self.element()[0], [],
        min: "1960"
        max: "1990"
        start: "1959-12"
        # end: "1960-07"
        end: "1990-01"
        zoomable: true
        stack: false
        # minHeight: "210px"
        height: "120px"
        # maxHeight: "200px"
        dataAttributes: "all"
        type: "point"
        align: "center"
        # width: "800px"
        selectable: false
        # 'timeAxis.scale': 'month'
        # autoResize: false
        # template: (item) ->
        #   console.log item
        #   "<div class='vis-dot' data-title='#{item.id}'></div>"
        # showMajorLabels: false
        # showMinorLabels: false
        # groupOrder: (x, y) ->
        #   return -1 if x.position < y.position
        #   return 1 if x.position > y.position
        #   return 0
      )

      item_click = (id) ->
        self.or.routing.set_packed(
          modal: true
          tag: 'or-chronology-detail'
          id: id
        )
        # console.log item

      self.timeline.on 'click', (props) ->
        item_click(props.item) if props.what == 'item'

      $(self.root).on 'click', '.or-excess button', (event) ->
        self.override_excess = true
        self.default_params.per_page = 5000
        self.search()

    self.element = -> $(self.root).find('.or-timeline')
    self.excess = -> !self.override_excess && self.data.total > self.default_params.per_page
    self.trivial = -> self.data.total == 0
    self.on 'mount', ->
      self.setup()
    self.or.bus.on 'packed-data', (data) -> self.search()
  </script>

</or-filtered-chronology>