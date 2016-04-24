<or-magazine>
  
  <or-paper item={opts.item}></or-paper>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      if self.opts.item
        self.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{self.or.config.api_url}/api/items/magazines/#{self.opts.id}"
          success: (data) ->
            # console.log data
            self.opts.item = data
            self.cache_attributes()
            self.update()
        )

    self.cache_attributes = ->
      try
        self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e
  </script>
  
</or-magazine>