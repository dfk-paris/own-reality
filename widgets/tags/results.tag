<or-results>

  <div class="or-search-header">{tcap('search_result', {count: 'other'})}</div>
  
  <div class="result-tabs">
    <div class="controls" if={wApp.data.aggregations}>
      <a name="sources" class={current: (current_tab == 'sources')}>
        {t('source', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['sources'].doc_count})
      </a>
      <a name="chronology" class={current: (current_tab == 'chronology')}>
        {t('exhibition', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['chronology'].doc_count})
      </a>
      <a name="interviews" class={current: (current_tab == 'interviews')}>
        {t('interview', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['interviews'].doc_count})
      </a>
      <a name="magazines" class={current: (current_tab == 'magazines')}>
        {t('magazine', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['magazines'].doc_count})
      </a>
      <a name="articles" class={current: (current_tab == 'articles')}>
        {t('article', {count: 'other', capitalize: true})}
        ({wApp.data.aggregations['articles'].doc_count})
      </a>
      <div class="clearfix"></div>
    </div>

    <or-pagination
      ref="pagination"
      total={wApp.data.total}
      per-page={wApp.data.per_page}
    />

    <div class="or-list" if={current_tab != 'chronology'}>
      <or-list-item
        each={item in wApp.data.results}
        item={item}
        search-result={true}
      />
    </div>

    <or-filtered-chronology
      if={current_tab == 'chronology'}
      items={wApp.data.results}
    />
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.current_tab = 'sources'

    tag.on 'mount', ->
      # Zepto(tag.root).find('.tab').hide()
      # Zepto(tag.root).find('.tab.sources').show()

      Zepto(tag.root).on 'click', '.controls a', (event) ->
        event.preventDefault()
        name = Zepto(event.target).attr('name')
        wApp.routing.packed type: name, page: 1

      wApp.bus.on 'results', tag.update
      wApp.bus.on 'type-aggregations', tag.update
      wApp.bus.on 'routing:query', tag.from_packed_data
      wApp.bus.on 'previous-result', onPreviousResult
      wApp.bus.on 'next-result', onNextResult
      tag.from_packed_data()

    tag.on 'unmount', ->
      wApp.bus.off 'next-result', onNextResult
      wApp.bus.off 'previous-result', onPreviousResult
      wApp.bus.off 'results', tag.update
      wApp.bus.off 'type-aggregations', tag.update
      wApp.bus.off 'routing:query', tag.from_packed_data

    tag.from_packed_data = ->
      tag.current_tab = wApp.routing.packed()['type'] || 'sources'
      tag.update()

    onPreviousResult = (oldId) ->
      oldIndex = resultIndexById(oldId)
      if oldIndex > 0
        newId = wApp.data.results[oldIndex - 1]._id
        wApp.routing.packed id: newId
      else
        if tag.refs.pagination.page() > 1
          tag.refs.pagination.previous()
          wApp.bus.one 'results', ->
            newId = wApp.data.results[wApp.data.results.length - 1]._id
            wApp.routing.packed id: newId

    onNextResult = (oldId) ->
      oldIndex = resultIndexById(oldId)
      console.log oldIndex
      if oldIndex < wApp.data.results.length - 1
        newId = wApp.data.results[oldIndex + 1]._id
        wApp.routing.packed id: newId
      else
        if tag.refs.pagination.page() < tag.refs.pagination.pages()
          tag.refs.pagination.next()
          wApp.bus.one 'results', ->
            newId = wApp.data.results[0]._id
            wApp.routing.packed id: newId

    resultIndexById = (id) ->
      for r, i in wApp.data.results
        return i if r._id == id
      return -1

  </script>
  
</or-results>