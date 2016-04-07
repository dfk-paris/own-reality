<or-general-filters>
  
  <form>
    <div>
      <or-delayed-input
        name="terms"
        type="text"
        placeholder={or.filters.t('full_text_search')}
        timeout={300}
      ></or-delayed-input>
    </div>

    <div>
      <label for="summary_only">
        <or-checkbox name="summary_only"></or-checkbox>
        <small>{or.filters.t('search_summary_only')}</small>
      </label>
    </div>

    <div>
      <or-slider min="1960" max="1989" name="date" />
    </div>

    <div>
      <or-clustered-facets name="attribute_facets"
        aggregations={aggregations}
      ></or-clustered-facets>
    </div>
  </form>

  <style type="text/scss">
    @import 'tmp/jquery-ui';
    @import 'tmp/jquery-ui.structure';
    @import 'tmp/jquery-ui.theme';
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      self.on 'or-change', (field) -> self.search()

      self.search()

    self.search = ->
      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: {
          terms: self.tags.terms.value()
          only_summary: self.tags.summary_only.value()
          lower: self.tags.date.value()[0]
          upper: self.tags.date.value()[1]
          attribute_ids: self.tags.attribute_facets.value()
        }
        success: (data) ->
          console.log data
          self.aggregations = data.aggregations
          self.fetch_attributes()
          
          self.or.data.results = data.records
          self.or.bus.trigger 'results'
      )

    self.fetch_attributes = ->
      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/lookup"
        data: {ids: self.attribute_ids()}
        success: (data) ->
          console.log data
          self.attrs = data
          self.extend_lookup(data)
          self.update()
      )

    self.extend_lookup = (data) ->
      for a in data
        self.or.cache.attr_lookup[a._source.id] = a._source

    self.attribute_ids = ->
      results = []
      for k, aggregation of self.aggregations
        for bucket in aggregation.buckets
          results.push bucket.key
      results

    window.e = self

  </script>

</or-general-filters>