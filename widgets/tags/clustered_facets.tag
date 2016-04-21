<or-clustered-facets>
  
  <div>
    <div class="or-selected">
      <span class="item" each={key in keys}>
        <or-attribute key={key} />
      </span>
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

      $(self.root).on 'click', '.or-selected .item', (event) ->
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