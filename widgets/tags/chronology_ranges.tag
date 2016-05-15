<or-chronology-ranges>
  
  <span>
    <ul>
      <li each={bucket in buckets()}>
        <a data-year={parent.year_for_bucket(bucket)}>
          {parent.year_for_bucket(bucket)} ({bucket.doc_count})
        </a>
      </li>
    </ul>
  </span>

  <style type="text/scss">
    or-chronology-ranges {
      a {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    
    self.initialized = false
    self.params = {
      type: 'chronology'
      year_ranges: true
      per_page: 50
    }

    self.on 'mount', ->
      $(self.root).on 'click', 'a[data-year]', (event) ->
        event.preventDefault()
        year = $(event.target).attr('data-year')
        self.params.year_ranges = year
        self.params.per_page = 500
        self.search()

      self.search()

    self.search = ->
      $.ajax(
        type: 'POST'
        url: "#{self.or.config.api_url}/api/entities/search"
        data: self.params
        success: (data) ->
          # console.log data
          unless self.initialized
            self.or.data = data
            self.initialized = true
          self.or.data.records = data.records
          # self.or.cache_attributes(self.attribute_ids())
          self.update()
          self.or.bus.trigger 'results'
      )


    self.year_for_bucket = (bucket) ->
      parseInt(bucket.from_as_string.split('-')[0])
    self.buckets = -> self.or.data.aggregations.year_ranges.buckets

  </script>

</or-chronology-ranges>