<!-- TODO: kann weg? -->
<or-item-metadata>
  
  <virtual if={opts.item}>
    <h2 if={opts.item._type == 'sources'}>
      <or-content-localized-value value={opts.item._source.title} />
    </h2>

    <div class="or-subtitle" if={opts.item._type == 'chronology'}>
      {t('exhibition', {count: 1, capitalize: true})} {t('in_country')}
      <or-attribute
        each={id in opts.item._source.attrs.ids[7][168]}
        key={id}
        shorten-to={100}
      />,
      {range_label()}
    </div>

    <div class="or-metadata">
      <virtual each={people, role_id in opts.item._source.people}>
        <h2>{lv(wApp.config.server.roles[role_id])}</h2>
        <or-people-list people={people} as-buttons={true} />
      </virtual>

      <div class="or-field" show={opts.item._type == 'sources'}>
        <strong>{t('source', {count: 1, capitalize: true})}:</strong>
        <or-journal-and-volume item={opts.item} as-button={true} />
      </div>
    </div>

    <div class="or-text" if={opts.item._type == 'sources'}>
      <div class="or-field">
        <or-content-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="or-text" if={opts.item._type == 'chronology'}>
      <div class="or-field">
        <or-content-localized-value value={opts.item._source.content} />
      </div>
    </div>

    <div
      if={opts.item._type == 'sources' || opts.item._type == 'chronology'}
      class="clearfix"
    ></div>
    
    <div class="or-field">
      <strong>{t('keyword', {count: 'other', capitalize: true})}:</strong>
      <or-attribute-list keys={attrs(6, 43)} />
    </div>

    <div class="or-field" if={opts.item._type == 'sources'}>
      <strong>{t('recommended_citation_style', {count: 1, capitalize: true})}:</strong>
      <or-citation item={opts.item} />
    </div>

    <div class="clearfix"></div>
  </virtual>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      # $(tag.root).on 'click', 'or-attribute', (event) ->
      #   event.preventDefault()
      #   if tag.clickable_properties()
      #     if window.confirm(tag.t('confirm_replace_search'))
      #       key = $(event.target).parents('or-attribute').attr('key')
      #       wApp.bus.trigger 'reset-search-with', attribs: [key]

      # $(tag.root).on 'click', 'or-person', (event) ->
      #   event.preventDefault()
      #   if tag.clickable_properties()
      #     if window.confirm(tag.t('confirm_replace_search'))
      #       role_id = $(event.target).parents('[data-role-id]').attr('data-role-id')
      #       key = $(event.target).attr('data-person-id')
      #       data = {people: {}}
      #       data.people[role_id] = [key]
      #       wApp.bus.trigger 'reset-search-with', data

      $(tag.root).on 'click', '.or-journal', (event) ->
        event.preventDefault()
        if tag.clickable_properties()
          if window.confirm(tag.t('confirm_replace_search'))
            key = $(event.target).attr('data-journal-name')
            wApp.bus.trigger 'reset-search-with', journals: [key]

    tag.clickable_properties = -> wApp.config.is_search
    tag.range_label = -> wApp.utils.range_label(tag.opts.item)
    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]

  </script>

</or-item-metadata>