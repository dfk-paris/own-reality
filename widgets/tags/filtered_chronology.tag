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
      # wApp.bus.on 'routing:query', tag.search
      wApp.bus.on 'results', newData

    tag.on 'unmount', ->
      # wApp.bus.off 'routing:query', tag.search
      wApp.bus.off 'results', newData

    # tag.params = ->
    #   return {
    #     type: 'chronology'
    #     per_page: tag.default_params.per_page
    #     terms: wApp.routing.packed()['terms']
    #     lower: wApp.routing.packed()['lower'] || 1960
    #     upper: wApp.routing.packed()['upper'] || 1989
    #     attribute_ids: wApp.routing.packed()['attribs']
    #     people_ids: wApp.routing.packed()['people']
    #   }

    newData = ->
      tag.data = wApp.data
      tag.data.results = tag.data.results.sort (x, y) ->
        a = x._source.from_date
        b = y._source.from_date
        if a < b
          -1
        else if a > b
          1
        else
          0

      tag.new_data()

    tag.new_data = (params) ->
      # console.log 'chrono params:', params
      first = tag.data.results[0]
      last = tag.data.results[tag.data.results.length - 1]
      lower = new Date(first._source.from_date)
      upper = new Date(last._source.from_date)

      # console.log('---', new Date("#{lower.getYear() - 1}-12-01"), '---', new Date("#{upper.getYear() + 1}-01-31"))

      tag.timeline.setOptions(
        min: new Date("#{lower.getFullYear() - 1}-12-01")
        max: new Date("#{upper.getFullYear() + 1}-01-31")
        start: new Date("#{lower.getFullYear() - 1}-12-01")
        end: new Date("#{upper.getFullYear() + 1}-01-31")
      )

      new_data = []
      tag.item_lookup = {}

      for o in tag.data["results"]
        item = {
          id: o._source.id
          start: new Date(o._source.from_date)
          title: tag.lv(o._source.title)
          # "end": o._source.to_date
          # "content": "#{group_for(o)}"
          # "group": group_for(o)
          # "content": o._source.title[ss.locale] || "Noname"
        }

        if item.start
          tag.item_lookup[item.id] = o
          new_data.push item
          # console.log item.start
        # else
        #   console.log item

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
        # stack: false
        # minHeight: "260px"
        # height: "250px"
        # maxHeight: "200px"
        dataAttributes: "all"
        type: "point"
        align: "center"
        # width: "800px"
        selectable: false
        timeAxis: {scale: 'year'}
        # autoResize: false
        # template: (item) ->
        #   console.log item
        #   "<div class='vis-dot' data-title='#{item.id}'></div>"
        showMajorLabels: false
        tooltip: {overflowMethod: 'cap'}
        # showMinorLabels: false
        # groupOrder: (x, y) ->
        #   return -1 if x.position < y.position
        #   return 1 if x.position > y.position
        #   return 0
      )

      item_click = (id) ->
        wApp.routing.packed(
          modal: true
          tag: 'or-paper'
          id: id
        )
        # console.log item

      item_hover = (props) ->
        # TODO: fix tooltip placement
        # dot = Zepto(props.event.target)
        # tt = Zepto('.vis-tooltip')
        # d = 20

        # if dot.position().top - d - tt.height() > 0
        #   tt.css 'top': dot.position().top - d - tt.height()
        # else
        #   tt.css 'top': dot.position().top + d

        # tt.css 'left', tt.position().left + 20

      tag.timeline.on 'click', (props) ->
        item_click(props.item) if props.what == 'item'

      tag.timeline.on 'itemover', item_hover

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