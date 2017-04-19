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

    tag.modal_tag = ->
      mapping = {
        'magazines': 'or-magazine',
        'articles': 'or-paper',
        'interviews': 'or-interview'
      }
      mapping[tag.opts.item._type]

    tag.on 'mount', ->
      unless tag.opts.item
        wApp.cache.objects(tag.opts.type)
        wApp.bus.on 'object-data', ->
          tag.opts.item = wApp.cache.data.objects[tag.opts.type][tag.opts.id]
          tag.update()

      $(tag.root).on 'click', 'a', (event) ->
        event.preventDefault()
        if base = tag.opts.orSearchUrl
          hash = ownreality.routing.pack_to_string(
            journals: [tag.opts.item._source.journal_short]
          )
          url = "#{base}/#?q=#{hash}"
          window.document.location = url
        else
          wApp.routing.packed(
            modal: 'true',
            tag: tag.modal_tag(),
            id: tag.opts.item._id
            clang: ownreality.config.locale
          )

  </script>

</or-item>