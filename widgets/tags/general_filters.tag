<or-general-filters>

  <div class="or-search-header">{tcap('criterion', {count: 'other'})}</div>
  
  <form>
    <div class="form-control">
      <or-delayed-input
        ref="terms"
        type="text"
        placeholder={t('full_text_search')}
        timeout={300}
      ></or-delayed-input>
    </div>

    <div class="form-control">
      <or-slider min="1960" max="1989" ref="date" />
    </div>

    <div class="form-control">
      <or-clustered-facets
        ref="attribute_facets"
        aggregations={aggregations}
        or-base-target-people-url={opts.orBaseTargetPeopleUrl}
        or-base-target-attribs-url={opts.orBaseTargetAttribsUrl}
      ></or-clustered-facets>
    </div>
  </form>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.type = -> wApp.routing.packed()['type'] || 'sources'
    
    tag.on 'mount', ->
      wApp.searchContext = true
      wApp.config.is_search = true

      # wApp.bus.one 'routing:path', tag.search
      wApp.bus.on 'routing:query', tag.search
      wApp.bus.on 'reset-search-with', tag.reset_search

      # tag.search()

    tag.on 'unmount', ->
      wApp.bus.off 'reset-search-with', tag.reset_search
      wApp.bus.off 'routing:query', tag.search
      wApp.searchContext = false

    tag.reset_search = (what = {}) ->
      tag.refs.terms.reset(false)
      tag.refs.date.reset(false)
      tag.refs.attribute_facets.reset(false)
      tag.refs.attribute_facets.add(what, false)

    tag.params = ->
      return {
        terms: wApp.routing.packed()['terms']
        lower: wApp.routing.packed()['lower'] || 1960
        upper: wApp.routing.packed()['upper'] || 1989
        attribute_ids: wApp.routing.packed()['attribs']
        people_ids: wApp.routing.packed()['people']
        journal_names: wApp.routing.packed()['journals']
        exclude: ['23572', '23573', '23571']
      }

    tag.search = ->
      params = tag.params()
      # console.log params, tag.type()

      $.ajax(
        type: 'POST'
        url: "#{wApp.api_url()}/api/entities/search"
        data: JSON.stringify($.extend({}, params, {
          search_type: 'count'
        }))
        success: (data) ->
          # console.log 'aggs:', params, data
          wApp.data.aggregations = {
            articles: {doc_count: 0}
            magazines: {doc_count: 0}
            interviews: {doc_count: 0}
            sources: {doc_count: 0},
            chronology: {doc_count: 0}
          }
          for bucket in data.aggregations.type.buckets
            wApp.data.aggregations[bucket.key] = bucket
          wApp.bus.trigger 'type-aggregations'
      )

      if tag.type() == 'sources'
        params.per_page = 10
        # params.people_ids = tag.people_ids
        # params.journal_names = tag.journal_names
      else if tag.type() == 'chronology'
        params.per_page = 20
      else
        params.per_page = 500

      $.ajax(
        type: 'POST'
        url: "#{wApp.api_url()}/api/entities/search"
        data: JSON.stringify($.extend({}, params, {
          type: tag.type()
          page: wApp.routing.packed()['page'] || 1
        }))
        success: (data) ->
          # console.log 'entries:', params, data
          tag.aggregations = data.aggregations
          wApp.cache.attributes(tag.attribute_ids())
          wApp.cache.people(tag.people_ids())
          wApp.data.results = data.records
          wApp.data.total = data.total
          wApp.data.per_page = data.per_page
          wApp.bus.trigger 'results'
      )

    tag.attribute_ids = ->
      results = []
      for k, aggregation of tag.aggregations.attribs
        for bucket in aggregation.buckets
          results.push bucket.key
      results

    tag.people_ids = ->
      results = []
      for k, aggregation of tag.aggregations.people
        for bucket in aggregation.buckets
          results.push bucket.key
      results

  </script>

</or-general-filters>