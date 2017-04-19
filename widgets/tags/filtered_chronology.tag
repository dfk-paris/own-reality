<or-filtered-chronology>
  
  <div show={!excess() && !trivial()} class="or-timeline" />
  <div class="edge">
    <div show={excess()} class="or-excess" style="display: none">
      {t('chronology', {capitalize: true})}:
      {t('too_much_data')} ({total()})
      <div>
        <button onclick={overrideExcess}>{t('show_all')}</button>
      </div>
    </div>
    <div show={trivial()}>
      {t('no_data')}
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    tag.default_params = {
      per_page: 100
    }

    tag.on 'mount', ->
      tag.setup()
      wApp.bus.on 'routing:query', tag.search

    tag.on 'unmount', ->
      wApp.bus.off 'routing:query', tag.search

    tag.params = ->
      return {
        type: 'chronology'
        per_page: tag.default_params.per_page
        terms: wApp.routing.packed()['terms']
        lower: wApp.routing.packed()['lower'] || 1960
        upper: wApp.routing.packed()['upper'] || 1989
        attribute_ids: wApp.routing.packed()['attribs']
        people_ids: wApp.routing.packed()['people']
      }

    tag.search = ->
      Zepto.ajax(
        type: 'POST'
        url: "#{wApp.config.api_url}/api/entities/search"
        data: JSON.stringify(tag.params())
        success: (data) ->
          # console.log 'chrono data:', data
          tag.data = data
          tag.ready = true
          tag.new_data(tag.params()) unless tag.excess() || tag.trivial()
      )

    tag.new_data = (params) ->
      # console.log 'chrono params:', params

      tag.timeline.setOptions(
        min: "#{params.lower - 1}-12-01"
        max: "#{params.upper}-01-31"
        start: "#{params.lower - 1}-12-01"
        end: "#{params.upper}-01-31"
      )

      new_data = []
      tag.item_lookup = {}

      for o in tag.data["records"]
        item = {
          id: o._source.id
          start: new Date(o._source.from_date)
          title: o._source.title[wApp.config.locale] || "Noname" 
          # "end": o._source.to_date
          # "content": "#{group_for(o)}"
          # "group": group_for(o)
          # "content": o._source.title[ss.locale] || "Noname"
        }

        if item.start
          tag.item_lookup[item.id] = o
          new_data.push item
        # else
          # console.log item

      # console.log 'tl data:', new_data
      tag.timeline.setItems new_data
      # scope.listing.chrono.aggregations = data.aggregations['attr.4.2'].buckets
      tag.update()


    tag.setup = ->
      # $(tag.root).find('.or-timeline').on 'click', '.vis-dot', (event) ->
      #   item = $(event.target).parents('.vis-point').data()

      tag.timeline = new vis.Timeline(tag.element()[0], [],
        min: "1959-12-01"
        max: "1990-01-31"
        start: "1959-12-01"
        # end: "1960-07"
        end: "1990-01-31"
        zoomable: true
        zoomMin: 864000000
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
        wApp.routing.packed(
          modal: true
          tag: 'or-chronology-detail'
          id: id
        )
        # console.log item

      tag.timeline.on 'click', (props) ->
        item_click(props.item) if props.what == 'item'

    tag.overrideExcess = (event) ->
      event.preventDefault()
      tag.override_excess = true
      tag.default_params.per_page = 5000
      tag.search()

    tag.total = -> if tag.data then tag.data.total else 0
    tag.element = -> Zepto(tag.root).find('.or-timeline')
    tag.excess = -> tag.ready && !tag.override_excess && tag.data.total > tag.default_params.per_page
    tag.trivial = -> tag.total() == 0
    
  </script>

</or-filtered-chronology>