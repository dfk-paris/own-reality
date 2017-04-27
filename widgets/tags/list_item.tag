<or-list-item>

  <div class="or-item-frame">
    <or-icon which="right" />

    <div class="or-item" onclick={openPaper}>
      <virtual if={opts.item && opts.item._type == 'sources'}>
        <or-medium item={opts.item} />
        <or-people-list people={opts.item._source.people[12063]} />
        <a
          class="or-modal-trigger"
        >
          <or-localized-value class="or-title" value={opts.item._source.title} />
        </a>
        <or-journal-and-volume item={opts.item} />
        <or-localized-value
          class="or-text"
          value={opts.item._source.interpretation}
        />
      </virtual>

      <virtual if={opts.item && opts.item._type == 'interviews'}>
        <or-medium item={opts.item} />
        <or-people-list people={opts.item._source.people[16530]} />
        <a
          if={hasHTML()}
        >
          <or-localized-value class="or-title" value={opts.item._source.title} />
        </a>
        <or-localized-value
          if={!hasHTML()}
          class="or-title"
          value={opts.item._source.title}
        />
      </virtual>

      <virtual if={opts.item && opts.item._type == 'articles'}>
        <or-pdf-link item={opts.item} download={true} />

        <or-people-list people={opts.item._source.people[16530]} />
        <a
          class="or-title"
          if={hasHTML()}
        >{lv(opts.item._source.title)}</a>
        <span if={!hasHTML()} class="or-title">
          {lv(opts.item._source.title)}
        </span>
      </virtual>

      <virtual if={opts.item && opts.item._type == 'magazines'}>
        <or-medium item={opts.item} />
        <or-people-list people={opts.item._source.people[16530]} />
        <a
          if={hasHTML()}
        >
          <or-localized-value class="or-title" value={opts.item._source.title} />
        </a>
        <or-localized-value
          if={!hasHTML()}
          class="or-title"
          value={opts.item._source.title}
        />
      </virtual>

      <virtual if={opts.item && opts.item._type == 'chronology'}>
        <or-people-list people={opts.item._source.people[12064]} />
        <span class="or-title">{lv(opts.item._source.title)}</span>
        <div class="or-location">
          {t('exhibition', {count: 1, capitalize: true})} {t('in_country')}
          <or-attribute
            each={id in opts.item._source.attrs.ids[7][168]}
            key={id}
            shorten-to={100}
          />,
          {range_label()}
        </div>
      </virtual>
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      unless tag.opts.item
        wApp.bus.on 'object-data', ->
          id = parseInt(tag.opts.id)
          tag.opts.item = wApp.cache.data.object_index[tag.opts.type][id]
          tag.update()
        wApp.cache.objects(tag.opts.type)

    tag.openPaper = (event) ->
      event.preventDefault()
      wApp.routing.packed(
        modal: 'true',
        tag: 'or-paper',
        id: tag.opts.item._id
        clang: wApp.config.locale
      )

    tag.hasHTML = ->
      html = tag.opts.item._source.html
      html && html[tag.locale()]

    tag.range_label = -> wApp.utils.range_label(tag.opts.item)

  </script>

</or-list-item>