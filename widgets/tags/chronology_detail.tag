<or-chronology-detail>
  
  <div class="chronology-detail">
    <or-item-metadata item={item} />
  </div>
    
  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      $.ajax(
        type: 'GET'
        url: "#{wApp.config.api_url}/api/items/chronology/#{tag.opts.id}"
        success: (data) ->
          # console.log data
          tag.item = data.docs[0]
          console.log data
          wApp.cache.attributes(tag.item._source.attrs.ids[6][43])
          wApp.cache.attributes(tag.item._source.attrs.ids[7][168])
          tag.update()
      )
  </script>

</or-chronology-detail>