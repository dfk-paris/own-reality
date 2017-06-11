<or-register>

  <div>
    <div if={isCategory()} class="or-search-header">{category_label()}</div>

    <virtual if={buckets}>
      <select ref="currentBucket" onchange={bucketChanged}>
        <option
          each={bucket in ordered_buckets()}
          value={bucket.key}
        >{bucket.key.toUpperCase()} ({bucket.doc_count})</option>
      </select>
    </virtual>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    window.t = tag

    tag.on 'mount', ->
      tag.fetch(true)
      wApp.bus.on 'locale-change', onLocaleChange

    tag.on 'unmount', ->
      wApp.bus.off 'locale-change', onLocaleChange

    tag.bucketChanged = (event) ->
      key = Zepto(tag.refs.currentBucket).val()
      tag.initial = key
      tag.fetch()

    onLocaleChange = ->
      if tag.opts.orType == 'attribs'
        tag.fetch()
      tag.update()

    tag.fetch = (first = false) ->
      params = {
        type: tag.opts.orType
        locale: tag.locale()
        per_page: 1500
      }

      if first
        params['register'] = true
        params['per_page'] = 1500
      else
        params['initial'] = tag.initial

      if tag.opts.orType == 'attribs'
        params['sort'] = {"name.#{tag.locale()}": 'asc'}
        params['kind_id'] = 43
        params['klass_id'] = 6
        params['category_id'] = tag.opts.orCategoryId

      if tag.opts.orType == 'people'
        params['sort'] = [{last_name: 'asc'}, {first_name: 'asc'}]

      # console.log params
      $.ajax(
        type: 'post',
        url: "#{wApp.api_url()}/api/entities/search"
        data: JSON.stringify(params)
        contentType: "application/json; charset=utf-8"
        success: (data) ->
          if first
            # console.log data
            tag.buckets = data.aggregations.register.buckets
            tag.update()
            tag.initial = 'a'
            tag.fetch()
          else
            tag.opts.bus.trigger 'register-results', data, tag.initial
      )

    tag.ordered_buckets = -> 
      tag.buckets.sort (x, y) -> wApp.utils.compare(x.key, y.key)
    tag.isCategory = -> tag.opts.orType == 'attribs'
    tag.category_label = ->
      # console.log 'label', tag.opts.orCategoryId
      # console.log wApp.config.server.categories
      tag.lv(wApp.config.server.categories[tag.opts.orCategoryId])

  </script>

</or-register>