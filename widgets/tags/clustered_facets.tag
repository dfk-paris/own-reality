<or-clustered-facets>
  
  <div>
    <div class="or-selected">
      <span class="item" each={key in keys}>
        <or-attribute key={key} />
      </span>
    </div>

    <div
      class="or-bucket"
      each={key, aggregation in opts.aggregations.people}
      if={aggregation.buckets.length > 0}
    >
      <a
        href="#"
        class="or-show-all"
        show={many_buckets(aggregation)}
        data-id={key}
        data-type="people"
      >
        {parent.or.filters.t('show_all')}
      </a>
      <div class="or-role">
        {parent.or.filters.l(parent.or.config.server.roles[key])}
      </div>
      <div class="or-value" each={bucket in limit_buckets(key, aggregation)}>
        •
        <a class="or-select"><or-person person-id={bucket.key} /></a>
        ({bucket.doc_count})
      </div>
    </div>

    <div
      class="or-bucket"
      each={key, aggregation in opts.aggregations.attrs}
      if={aggregation.buckets.length > 0}
    >
      <a
        href="#"
        class="or-show-all"
        show={many_buckets(aggregation)}
        data-id={key}
        data-type="attrs"
      >
        {parent.or.filters.t('show_all')}
      </a>
      <div class="or-category">
        {parent.or.filters.l(parent.or.config.server.categories[key])}
      </div>
      <div class="or-value" each={bucket in limit_buckets(key, aggregation)}>
        •
        <a class="or-select"><or-attribute key={bucket.key} /></a>
        ({bucket.doc_count})
      </div>
    </div>
  </div>

  <style type="text/scss">
    or-clustered-facets {
      a {
        cursor: pointer;
      }

      a.or-show-all {
        font-size: 0.7rem;
      }

      .item {
        cursor: pointer;
        font-size: 0.7rem;
        border-radius: 3px;
        padding: 0.2rem;
        background-color: darken(#ffffff, 20%);
        white-space: nowrap;
        display: inline-block;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
      }

      .or-bucket {
        margin-top: 1rem;

        .or-show-all {
          display: block;
          float: right;
        }

        .or-category, .or-role {
          margin-bottom: 0.1rem;
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or
    self.keys = []
    self.expanded = {}

    self.on 'mount', ->
      $(self.root).on 'click', '.or-bucket a.or-select', (event) ->
        event.preventDefault()
        key = $(event.target).parents('or-attribute').attr('key')
        if self.keys.indexOf(key) == -1
          self.keys.push(key)
          self.notify()

      $(self.root).on 'click', '.or-selected .item', (event) ->
        event.preventDefault()
        key = $(event.target).parents('or-attribute').attr('key')
        if self.keys.indexOf(key) != -1
          i = self.keys.indexOf(key)
          self.keys.splice(i, 1)
          self.notify()

      $(self.root).on 'click', '.or-show-all', (event) ->
        event.preventDefault()
        key = $(event.target).attr('data-id')
        type = $(event.target).attr('data-type')
        agg = self.opts.aggregations[type][key]
        if self.many_buckets(agg) 
          if self.countless_buckets(agg)
            console.log 'dialog', agg.buckets.length
          else
            self.expanded[key] = !self.expanded[key]
            self.update()
        
    self.notify = ->
      self.update()
      if self.parent
        self.parent.trigger('or-change', self)

    self.limit_buckets = (key, agg) ->
      if self.expanded[key] then agg.buckets else agg.buckets.slice(0, 5)
    self.many_buckets = (agg) -> agg.buckets.length > 5
    self.countless_buckets = (agg) -> agg.buckets.length > 20

    self.value = -> self.keys

  </script>
</or-clustered-facets>