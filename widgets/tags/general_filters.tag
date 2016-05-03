<or-general-filters>
  
  <form>
    <div class="form-control">
      <or-delayed-input
        name="terms"
        type="text"
        placeholder={or.filters.t('full_text_search')}
        timeout={300}
      ></or-delayed-input>
    </div>

    <div class="form-control">
      <label for="summary_only">
        <or-checkbox name="summary_only"></or-checkbox>
        <small>{or.filters.t('search_summary_only')}</small>
      </label>
    </div>

    <div class="form-control">
      <or-slider min="1960" max="1989" name="date" />
    </div>

    <div class="form-control">
      <or-clustered-facets name="attribute_facets"
        aggregations={aggregations}
      ></or-clustered-facets>
    </div>
  </form>

  <style type="text/scss">
    @import 'tmp/jquery-ui';
    @import 'tmp/jquery-ui.structure';
    @import 'tmp/jquery-ui.theme';

    or-general-filters {
      .form-control {
        margin-bottom: 1rem;

        input[type=text] {
          width: 100%;
        }

        input[type=checkbox] {
          margin-right: 0.5rem;
          position: relative;
          top: 2px;
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or
    self.type = 'sources'

    self.on 'mount', ->
      self.on 'or-change', ->
        self.or.bus.trigger 'filter-change', self.params()
        self.search()
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
        self.search()

      self.trigger 'or-change'

    self.params = ->
      return {
        terms: self.tags.terms.value()
        only_summary: self.tags.summary_only.value()
        lower: self.tags.date.value()[0] || 1960
        upper: self.tags.date.value()[1] || 1989
        attribute_ids: self.tags.attribute_facets.value()
      }

    self.search = ->
      params = self.params()

      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: $.extend({}, params, {
          search_type: 'count'
        })
        success: (data) ->
          # console.log 'aggs:', data
          self.or.data.aggregations = {
            articles: {doc_count: 0}
            magazines: {doc_count: 0}
            interviews: {doc_count: 0}
            sources: {doc_count: 0}
          }
          for bucket in data.aggregations.type.buckets
            self.or.data.aggregations[bucket.key] = bucket
          self.or.bus.trigger 'type-aggregations'
      )

      if self.type == 'sources'
        params.people_ids = self.people_ids
        params.journal_names = self.journal_names
      else
        params.per_page = 500

      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: $.extend({}, params, {
          type: self.type
        })
        success: (data) ->
          console.log data
          self.aggregations = data.aggregations
          self.or.cache_attributes(self.attribute_ids())
          self.or.data.results = data.records
          self.or.bus.trigger 'results'
      )

    self.attribute_ids = ->
      results = []
      for k, aggregation of self.aggregations.attrs
        for bucket in aggregation.buckets
          results.push bucket.key
      results
  </script>

</or-general-filters>