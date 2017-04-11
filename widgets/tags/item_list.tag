<or-item-list>

  <or-pagination total={opts.total} per-page={opts.perPage} />
  
  <or-list-item
    each={item in opts.items}
    item={item}
  />

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      unless tag.opts.items
        $.ajax(
          type: 'post'
          url: "#{wApp.config.api_url}/api/entities/search"
          data: JSON.stringify(
            type: tag.opts.type
            per_page: 100
          )
          success: (data) ->
            # console.log data
            tag.opts.items = data.records
            tag.update()
        )
  </script>

</or-item-list>