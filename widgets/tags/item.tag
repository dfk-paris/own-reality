<or-item>

  <a href="#">
    <or-localized-value
      if={!opts.label}
      class="or-title"
      value={opts.item._source.title}
    />
    <span if={opts.label}>{opts.label}</span>
  </a>

  <script type="text/coffee">
    self = this

    self.modal_tag = ->
      mapping = {
        'magazines': 'or-magazine',
        'articles': 'or-paper',
        'interviews': 'or-interview'
      }
      mapping[self.opts.item._type]

    self.on 'mount', ->
      unless self.opts.item
        self.or.fetch_objects(self.opts.type)
        self.or.bus.on 'object-data', ->
          self.opts.item = self.or.cache.object_index[self.opts.type][self.opts.id]
          self.update()

      $(self.root).on 'click', 'a', (event) ->
        event.preventDefault()
        if base = self.opts.orSearchUrl
          hash = ownreality.routing.pack_to_string(
            journals: [self.opts.item._source.journal_short]
          )
          url = "#{base}/#?q=#{hash}"
          window.document.location = url
        else
          self.or.routing.set_packed(
            modal: 'true',
            tag: self.modal_tag(),
            id: self.opts.item._id
            clang: ownreality.config.locale
          )

    self.ld = self.or.i18n.ld
    self.t = self.or.i18n.t
  </script>

</or-item>