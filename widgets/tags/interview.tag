<or-interview>
  
  <div>
    <or-item-metadata item={opts.item} />
    <or-paper item={opts.item} />
  </div>

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      if tag.opts.item
        tag.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{wApp.config.api_url}/api/items/interviews/#{tag.opts.id}"
          success: (data) ->
            # console.log data
            tag.opts.item = data.docs[0]
            tag.cache_attributes()
            tag.update()
        )

    tag.cache_attributes = ->
      try
        wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e
  </script>

</or-interview>