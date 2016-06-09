<or-chronology-detail>
  
  <div class="chronology-detail">
    <or-item-metadata item={item} />
  </div>
    
  <script type="text/coffee">
    self = this
    
    self.on 'mount', ->
      $.ajax(
        type: 'GET'
        url: "#{self.or.config.api_url}/api/items/chronology/#{self.opts.id}"
        success: (data) ->
          # console.log data
          self.item = data.docs[0]
          console.log data
          self.or.cache_attributes(self.item._source.attrs.ids[6][43])
          self.or.cache_attributes(self.item._source.attrs.ids[7][168])
          self.update()
      )

    self.t = self.or.i18n.t
  </script>

</or-chronology-detail>