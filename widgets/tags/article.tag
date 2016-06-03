<or-article>
  
<div>
    <or-item-metadata item={opts.item} />
    <or-paper item={opts.item} />
  </div>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      if self.opts.item
        self.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{self.or.config.api_url}/api/items/articles/#{self.opts.id}"
          success: (data) ->
            # console.log data
            self.opts.item = data.docs[0]
            self.cache_attributes()
            self.update()
        )

    self.cache_attributes = ->
      try
        self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e
  </script>
  
</or-article>