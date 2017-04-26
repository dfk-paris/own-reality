<or-source>
  <div>
    <or-language-selector locales={['de', 'fr']} />
    <or-item-metadata item={opts.item} />
  </div>

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      if tag.opts.item
        tag.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{wApp.api_url()}/api/items/sources/#{tag.opts.id}"
          success: (data) ->
            # console.log data
            tag.opts.item = data.docs[0]
            tag.cache_attributes()
            tag.update()
        )

    tag.cache_attributes = ->
      wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])
  </script>
</or-source>