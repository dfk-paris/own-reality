<or-chronology-ranges>
  
  <span if={wApp.data.aggregations}>
    <ul>
      <li each={bucket in buckets()}>
        <a data-year={year_for_bucket(bucket)}>
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
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      tag.initialized = false
      tag.params = {
        type: 'chronology'
        year_ranges: true
        per_page: 50
      }

      Zepto(tag.root).on 'click', 'a[data-year]', (event) ->
        event.preventDefault()
        year = $(event.target).attr('data-year')
        tag.params.year_ranges = year
        tag.params.per_page = 500
        tag.search()

      tag.search()

    tag.search = ->
      Zepto.ajax(
        type: 'POST'
        url: "#{wApp.config.api_url}/api/entities/search"
        data: JSON.stringify(tag.params)
        success: (data) ->
          console.log 'chrono', data
          unless tag.initialized
            wApp.data = data
            tag.initialized = true
            tag.params.year_ranges = 1960
            tag.search()
          else
            wApp.cache.data.records = data.records
            wApp.cache.attributes(tag.attribute_ids())
            wApp.bus.trigger 'results'
            tag.update()
      )

    tag.attribute_ids = ->
      ids = []
      for r in wApp.data.records
        for id in r._source.attrs.ids[7][168]
          ids.push(id)
      ids

    tag.year_for_bucket = (bucket) ->
      parseInt(bucket.from_as_string.split('-')[0])
    tag.buckets = -> wApp.data.aggregations.year_ranges.buckets

  </script>

</or-chronology-ranges>