<or-source>
  <div>
    <or-language-selector locales={['de', 'fr']} />
    <or-item-metadata item={opts.item} />
  </div>

  <style type="text/scss">
    or-source, [riot-tag=or-source] {
      or-language-selector {
        display: block;
        float: right;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      if self.opts.item
        self.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{self.or.config.api_url}/api/items/sources/#{self.opts.id}"
          success: (data) ->
            # console.log data
            self.opts.item = data.docs[0]
            self.cache_attributes()
            self.update()
        )

    self.cache_attributes = ->
      self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])
  </script>
</or-source>