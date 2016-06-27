<or-item-metadata>
  
  <div>
    <h2>
      <or-content-localized-value value={opts.item._source.title} />
    </h2>
    <div class="or-subtitle" show={opts.item._type == 'chronology'}>
      {t('exhibition', {count: 1, capitalize: true})} {or.i18n.t('in')}
      <or-attribute
        each={id in opts.item._source.attrs.ids[7][168]}
        key={id}
        shorten-to={100}
      />,
      {range_label()}
    </div>

    <div class="or-metadata">
      <div
        class="or-field"
        each={role_id, people in opts.item._source.people}
        data-role-id={role_id}
      >
        <strong>
          {parent.or.i18n.l(parent.or.config.server.roles[role_id])}:
        </strong>
        <or-people-list people={people} as-buttons={true} />
      </div>

      <div class="or-field" show={opts.item._type == 'sources'}>
        <strong>{t('source', {count: 1, capitalize: true})}:</strong>
        <or-journal-and-volume item={opts.item} as-button={true} />
      </div>
    </div>

    <div class="or-text" show={opts.item._type == 'sources'}>
      <div class="or-field">
        <or-content-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="or-text" show={opts.item._type == 'chronology'}>
      <div class="or-field">
        <or-content-localized-value value={opts.item._source.content} />
      </div>
    </div>

    <div
      class="clearfix"
      show={opts.item._type == 'sources' || opts.item._type == 'chronology'}
    ></div>
    
    <div class="or-field">
      <strong>{t('keyword', {count: 'other', capitalize: true})}:</strong>
      <or-attribute-list keys={opts.item._source.attrs.ids[6][43]} />
    </div>

    <div class="or-field" show={opts.item._type == 'sources'}>
      <strong>{t('recommended_citation_style', {count: 1, capitalize: true})}:</strong>
      <or-citation item={opts.item} />
    </div>

    <div class="clearfix"></div>
  </div>

  <style type="text/scss">
    or-item-metadata {
      h2 {
        margin-bottom: 1.5rem;
      }

      .or-subtitle {
        margin-top: -1.5rem;
        margin-bottom: 1.5rem;
        font-style: italic;
      }

      .or-field {
        margin-bottom: 1rem;

        strong {
          display: block;
        }
      }

      .or-metadata {
        float: left;
        width: 30%;
      }

      .or-text {
        float: left;
        width: 70%;
        box-sizing: border-box;
        padding-left: 1rem;
      }

      .clearfix {
        clear: both;
      }

      or-attribute, or-person, .or-journal {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      $(self.root).on 'click', 'or-attribute', (event) ->
        event.preventDefault()
        if self.clickable_properties()
          if window.confirm(self.or.i18n.t('confirm_replace_search'))
            key = $(event.target).parents('or-attribute').attr('key')
            self.or.bus.trigger 'reset-search-with', attribs: [key]

      $(self.root).on 'click', 'or-person', (event) ->
        event.preventDefault()
        if self.clickable_properties()
          if window.confirm(self.or.i18n.t('confirm_replace_search'))
            role_id = $(event.target).parents('[data-role-id]').attr('data-role-id')
            key = $(event.target).attr('data-person-id')
            data = {people: {}}
            data.people[role_id] = [key]
            self.or.bus.trigger 'reset-search-with', data

      $(self.root).on 'click', '.or-journal', (event) ->
        event.preventDefault()
        if self.clickable_properties()
          if window.confirm(self.or.i18n.t('confirm_replace_search'))
            key = $(event.target).attr('data-journal-name')
            self.or.bus.trigger 'reset-search-with', journals: [key]

    self.clickable_properties = -> self.or.config.is_search
    self.t = self.or.i18n.t
    self.range_label = -> self.or.range_label(self.opts.item)

  </script>

</or-item-metadata>