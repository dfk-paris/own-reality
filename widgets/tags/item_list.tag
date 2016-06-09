<or-item-list>

  <or-pagination total={opts.total} per-page={opts.perPage} />
  <or-list-item
    each={item in opts.items}
    item={item}
  />

  <style type="text/scss">
    or-item-list {
      or-pagination {
        display: block;
        text-align: right;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      unless self.opts.items
        $.ajax(
          type: 'post'
          url: "#{self.or.config.api_url}/api/entities/search"
          data: {
            type: self.opts.type
            per_page: 100
          }
          success: (data) ->
            # console.log data
            self.opts.items = data.records
            self.update()
        )
  </script>

</or-item-list>