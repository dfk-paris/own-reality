<or-filtered-chronology>
  
  <div>
    <div show={!excess() && !trivial()} class="or-timeline" />
    <div class="edge">
      <div show={excess()} class="or-excess" style="display: none">
        {t('chronology', {capitalize: true})}:
        {t('too_much_data')} ({total()})
        <div>
          <button>{t('show_all')}</button>
        </div>
      </div>
      <div show={trivial()}>
        {t('no_data')}
      </div>
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
      wApp.bus.on 'packed-data', tag.search

    tag.on 'unmount', ->
      wApp.bus.off 'packed-data', tag.search

    tag.params = ->
      return {
        type: 'chronology'
        per_page: tag.default_params.per_page
        terms: tag.or.routing.unpack()['terms']
        lower: tag.or.routing.unpack()['lower'] || 1960
        upper: tag.or.routing.unpack()['upper'] || 1989
        attribute_ids: tag.or.routing.unpack()['attribs']
        people_ids: tag.or.routing.unpack()['people']
      }

    tag.search = ->
      Zepto.ajax(
        type: 'POST'
        url: "#{tag.or.config.api_url}/api/entities/search"
        data: tag.params()
        success: (data) ->
          # console.log 'chrono data:', data
          tag.data = data
          tag.ready = true

          tag.new_data(tag.params()) unless tag.excess() || tag.trivial()
      )

    tag.new_data = (params) ->
      # console.log 'chrono params:', params

      tag.timeline.setOptions(
        min: "#{params.lower - 1}-12"
        max: "#{params.upper}-02"
        start: "#{params.lower - 1}-12"
        end: "#{params.upper}-02"
      )

      new_data = []
      tag.item_lookup = {}

      for o in tag.data["records"]
        item = {
          id: o._source.id
          start: o._source.from_date
          title: o._source.title[tag.or.config.locale] || "Noname" 
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
        tag.or.routing.set_packed(
          modal: true
          tag: 'or-chronology-detail'
          id: id
        )
        # console.log item

      tag.timeline.on 'click', (props) ->
        item_click(props.item) if props.what == 'item'

      Zepto(tag.root).on 'click', '.or-excess button', (event) ->
        tag.override_excess = true
        tag.default_params.per_page = 5000
        tag.search()

    tag.total = -> if tag.data then tag.data.total else 0
    tag.element = -> Zepto(tag.root).find('.or-timeline')
    tag.excess = -> tag.ready && !tag.override_excess && tag.data.total > tag.default_params.per_page
    tag.trivial = -> tag.total() == 0
    
  </script>

</or-filtered-chronology>