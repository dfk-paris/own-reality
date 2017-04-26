<or-item>

  <a href="#" if={opts.item}>
    <or-localized-value
      if={!opts.label}
      class="or-title"
      value={opts.item._source.title}
    />
    <span if={opts.label}>{opts.label}</span>
  </a>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      unless tag.opts.item
        wApp.bus.on 'object-data', ->
          tag.opts.item = wApp.cache.data.object_index[tag.opts.type][tag.opts.id]
          tag.update()
        wApp.cache.objects(tag.opts.type)

      $(tag.root).on 'click', 'a', (event) ->
        event.preventDefault()
        if base = tag.opts.orSearchUrl
          hash = wApp.routing.pack(
            journals: [tag.opts.item._source.journal_short]
          )
          url = "#{base}/#?q=#{hash}"
          window.document.location = url
        else
          wApp.routing.packed(
            modal: 'true',
            tag: 'or-paper'
            id: tag.opts.item._id
          )

  </script>

</or-item>