<or-clustered-facets>
  
  <div>
    <div class="or-selected">
      <a each={key in keys}>
        <small>
          <or-attribute key={key} />
        </small>
      </a>
    </div>

    <div
      class="or-bucket"
      each={key, aggregation in opts.aggregations}
      if={aggregation.buckets.length > 0}
    >
      <div class="or-category">
        {parent.or.filters.l(parent.or.config.server.categories[key])}
      </div>
      <div class="or-value" each={bucket in aggregation.buckets}>
        •
        <a><or-attribute key={bucket.key} /></a>
        ({bucket.doc_count})
      </div>
    </div>
  </div>

  <style type="text/scss">
    or-clustered-facets {
      a {
        cursor: pointer;
      }

      .or-bucket {
        margin-top: 1rem;

        .or-category {
          margin-bottom: 0.1rem;
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.keys = []

    self.on 'mount', ->
      $(self.root).on 'click', '.or-bucket a', (event) ->
        key = $(event.target).parents('or-attribute').attr('key')
        if self.keys.indexOf(key) == -1
          self.keys.push(key)
          self.notify()

      $(self.root).on 'click', '.or-selected a', (event) ->
        key = $(event.target).parents('or-attribute').attr('key')
        if self.keys.indexOf(key) != -1
          i = self.keys.indexOf(key)
          self.keys.splice(i, 1)
          self.notify()
        
    self.notify = ->
      self.update()
      if self.parent
        self.parent.trigger('or-change', self)

    self.value = -> self.keys

  </script>
</or-clustered-facets>