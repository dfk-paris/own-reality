<or-list-item>

  <div if={opts.item._type == 'sources'}>
    <or-medium item={opts.item} />
    <or-people-list people={opts.item._source.people[12063]} />
    <a class="or-modal-trigger" or-tag="or-source">
      <or-localized-value class="or-title" value={opts.item._source.title} />
    </a>
    <or-journal-and-volume item={opts.item} />
    <or-localized-value
      class="or-text"
      value={opts.item._source.interpretation}
    />
  </div>

  <div if={opts.item._type == 'interviews'}>
    <or-medium item={opts.item} />
    <or-people-list people={opts.item._source.people[16530]} />
    <a
      if={hasHTML()}
      onclick={openPaper}
    >
      <or-localized-value class="or-title" value={opts.item._source.title} />
    </a>
    <or-localized-value
      if={!hasHTML()}
      class="or-title"
      value={opts.item._source.title}
    />
  </div>

  <div if={opts.item._type == 'articles'}>
    <or-medium item={opts.item} />
    <or-people-list people={opts.item._source.people[16530]} />
    <a
      if={hasHTML()}
      onclick={openPaper}
    >
      <or-localized-value class="or-title" value={opts.item._source.title} />
    </a>
    <or-localized-value
      if={!hasHTML()}
      class="or-title"
      value={opts.item._source.title}
    />
  </div>

  <div if={opts.item._type == 'magazines'}>
    <or-medium item={opts.item} />
    <or-people-list people={opts.item._source.people[16530]} />
    <a
      if={hasHTML()}
      onclick={openPaper}
    >
      <or-localized-value class="or-title" value={opts.item._source.title} />
    </a>
    <or-localized-value
      if={!hasHTML()}
      class="or-title"
      value={opts.item._source.title}
    />
  </div>

  <div if={opts.item._type == 'chronology'}>
    <or-people-list people={opts.item._source.people[12064]} />
    <a
      onclick={openPaper}
    >
      <strong>
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </strong>
    </a>
    <em>
      {t('exhibition', {count: 1, capitalize: true})} {t('in_country')}
      <or-attribute
        each={id in opts.item._source.attrs.ids[7][168]}
        key={id}
        shorten-to={100}
      />,
      {range_label()}
    </em>
  </div>
  <div class="clearfix"></div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      unless tag.opts.item
        wApp.cache.objects(tag.opts.type)
        wApp.bus.on 'object-data', ->
          tag.opts.item = wApp.cache.data.object_index[tag.opts.type][tag.opts.id]
          tag.update()

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