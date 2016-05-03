<or-item-list>
  
  <div>
    <or-list-item
      each={item in opts.items}
      item={item}
    />
  </div>

  <script type="text/coffee">
    self = this
    self.or = window.or

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
        )
  </script>

</or-item-list>