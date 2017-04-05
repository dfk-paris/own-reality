<or-register>

  <div>
    <h3>{category_label()}</h3>

    <div each={bucket in ordered_buckets()} key={bucket.key}>
      <a>
        {bucket.key.toUpperCase()} ({bucket.doc_count})
      </a>
    </div>
  </div>

  <style type="text/scss">
    or-register {
      a {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      self.fetch(true)

      $(self.root).on 'click', 'a', (event) ->
        event.preventDefault()
        key = $(event.target).parents('div[key]').attr('key')
        self.initial = key
        self.fetch()

      self.or.bus.on 'locale-change', -> 
        if self.opts.orType == 'attribs'
          self.fetch()
        self.update()

    self.fetch = (first = false) ->
      params = {
        type: self.opts.orType
        locale: self.or.config.locale
        per_page: 1500
      }

      if first
        params['register'] = true
        params['per_page'] = 1500
      else
        params['initial'] = self.initial

      if self.opts.orType == 'attribs'
        params['sort'] = {"name.#{self.or.config.locale}": 'asc'}
        params['kind_id'] = 43
        params['klass_id'] = 6
        params['category_id'] = self.opts.orCategory

      if self.opts.orType == 'people'
        params['sort'] = [{last_name: 'asc'}, {first_name: 'asc'}]

      $.ajax(
        type: 'post',
        url: "#{self.or.config.api_url}/api/entities/search"
        data: JSON.stringify(params)
        contentType: "application/json; charset=utf-8"
        success: (data) ->
          if first
            # console.log data
            self.buckets = data.aggregations.register.buckets
            self.update()
            self.initial = 'a'
            self.fetch()
          else
            self.opts.bus.trigger 'register-results', data
      )

    self.ordered_buckets = -> 
      self.buckets.sort (x, y) -> self.or.compare(x.key, y.key)
    self.category_label = ->
      # console.log 'label', self.opts.orCategory
      self.or.i18n.l(self.or.config.server.categories[self.opts.orCategory])

  </script>

</or-register>