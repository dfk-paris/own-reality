<or-chronology-ranges>

  <virtual if={wApp.data.aggregations}>
    <select onchange={onChange}>
      <option
        each={bucket in buckets()}
        value={yearForBucket(bucket)}
      >
        {yearForBucket(bucket)}
      </option>
    </select>
  </span>

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
      tag.search()

    tag.onChange = (event) ->
      year = Zepto(event.currentTarget).val()
      tag.params.year_ranges = year
      tag.params.per_page = 500
      tag.search()

    tag.search = ->
      Zepto.ajax(
        type: 'POST'
        url: "#{wApp.api_url()}/api/entities/search"
        data: JSON.stringify(tag.params)
        success: (data) ->
          # console.log 'chrono', data
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

    tag.yearForBucket = (bucket) ->
      parseInt(bucket.from_as_string.split('-')[0])

    tag.buckets = -> wApp.data.aggregations.year_ranges.buckets

  </script>

</or-chronology-ranges>