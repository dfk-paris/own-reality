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
    self.type = 'sources'

    self.on 'mount', ->
      self.on 'or-change', (field) -> self.search()
      self.or.bus.on 'type-select', (type) ->
        self.type = type
        self.search()
      self.or.bus.on 'people-filter', (people) ->
        self.people_ids = (person.id for person in people)
        self.search()
      self.or.bus.on 'journals-filter', (journals) ->
        self.journal_names = []
        for journal in journals
          for locale, name of journal.title
            self.journal_names.push name
        console.log self.journal_names
        self.search()

      self.search()

    self.search = ->
      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: {
          search_type: 'count'
          terms: self.tags.terms.value()
          only_summary: self.tags.summary_only.value()
          lower: self.tags.date.value()[0]
          upper: self.tags.date.value()[1]
          attribute_ids: self.tags.attribute_facets.value()
          people_ids: self.people_ids
          journal_names: self.journal_names
        }
        success: (data) ->
          # console.log 'aggs:', data
          for bucket in data.aggregations.type.buckets
            self.or.data.aggregations[bucket.key] = bucket
          self.or.bus.trigger 'type-aggregations'
      )

      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: {
          type: self.type
          terms: self.tags.terms.value()
          only_summary: self.tags.summary_only.value()
          lower: self.tags.date.value()[0]
          upper: self.tags.date.value()[1]
          attribute_ids: self.tags.attribute_facets.value()
          people_ids: self.people_ids
          journal_names: self.journal_names
        }
        success: (data) ->
          console.log data
          self.aggregations = data.aggregations
          self.or.cache_attributes(self.attribute_ids())
          self.or.data.results = data.records
          self.or.bus.trigger 'results'
      )

    self.attribute_ids = ->
      results = []
      for k, aggregation of self.aggregations
        for bucket in aggregation.buckets
          results.push bucket.key
      results

    window.e = self

  </script>

</or-general-filters>