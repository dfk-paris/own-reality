<or-results>
  
  <div class="result-tabs">
    <div class="controls" if={wApp.data.aggregations}>
      <a name="sources" class={current: (current_tab == 'sources')}>
        {t('source', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['sources'].doc_count})
      </a>
      <a name="magazines" class={current: (current_tab == 'magazines')}>
        {t('magazine', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['magazines'].doc_count})
      </a>
      <a name="interviews" class={current: (current_tab == 'interviews')}>
        {t('interview', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['interviews'].doc_count})
      </a>
      <a name="articles" class={current: (current_tab == 'articles')}>
        {t('article', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['articles'].doc_count})
      </a>
      <div class="clearfix"></div>
    </div>

    <or-item-list
      items={wApp.data.results}
      total={wApp.data.total}
      per-page={wApp.data.per_page}
    />
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.current_tab = 'sources'

    tag.on 'mount', ->
      Zepto(tag.root).find('.tab').hide()
      Zepto(tag.root).find('.tab.sources').show()

      Zepto(tag.root).on 'click', '.controls a', (event) ->
        event.preventDefault()
        name = Zepto(event.target).attr('name')
        wApp.routing.packed type: name, page: 1

      wApp.bus.on 'results', tag.update
      wApp.bus.on 'type-aggregations', tag.update
      wApp.bus.on 'routing:query', tag.from_packed_data
      tag.from_packed_data()

    tag.on 'unmount', ->
      wApp.bus.off 'results', tag.update
      wApp.bus.off 'type-aggregations', tag.update
      wApp.bus.off 'routing:query', tag.from_packed_data

    tag.from_packed_data = ->
      tag.current_tab = wApp.routing.packed()['type'] || 'sources'
      tag.update()

  </script>
  
</or-results>