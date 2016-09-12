<or-general-filters>
  
  <form>
    <div class="form-control">
      <or-delayed-input
        name="terms"
        type="text"
        placeholder={or.i18n.t('full_text_search')}
        timeout={300}
      ></or-delayed-input>
    </div>

    <div class="form-control">
      <or-slider min="1960" max="1989" name="date" />
    </div>

    <div class="form-control">
      <or-clustered-facets
        name="attribute_facets"
        aggregations={aggregations}
        or-base-target-people-url={opts.orBaseTargetPeopleUrl}
        or-base-target-attribs-url={opts.orBaseTargetAttribsUrl}
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

    self.type = -> self.or.routing.unpack()['type'] || 'sources'
    
    self.on 'mount', ->
      self.or.config.is_search = true

      self.or.bus.on 'packed-data', (data) ->
        self.search()

    self.or.bus.on 'reset-search-with', (what = {}) ->
      self.tags.terms.reset(false)
      self.tags.date.reset(false)
      self.tags.attribute_facets.reset(false)

      # console.log what
      self.tags.attribute_facets.add(what, false)

    self.params = ->
      return {
        terms: self.or.routing.unpack()['terms']
        lower: self.or.routing.unpack()['lower'] || 1960
        upper: self.or.routing.unpack()['upper'] || 1989
        attribute_ids: self.or.routing.unpack()['attribs']
        people_ids: self.or.routing.unpack()['people']
        journal_names: self.or.routing.unpack()['journals']
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

      if self.type() == 'sources'
        # params.people_ids = self.people_ids
        # params.journal_names = self.journal_names
      else
        params.per_page = 500

      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: $.extend({}, params, {
          type: self.type()
          page: self.or.routing.unpack()['page'] || 1
        })
        success: (data) ->
          console.log data
          self.aggregations = data.aggregations
          self.or.cache_attributes(self.attribute_ids())
          self.or.cache_people(self.people_ids())
          self.or.data.results = data.records
          self.or.data.total = data.total
          self.or.bus.trigger 'results'
      )

    self.attribute_ids = ->
      results = []
      for k, aggregation of self.aggregations.attribs
        for bucket in aggregation.buckets
          results.push bucket.key
      results

    self.people_ids = ->
      results = []
      for k, aggregation of self.aggregations.people
        for bucket in aggregation.buckets
          results.push bucket.key
      results
  </script>

</or-general-filters>