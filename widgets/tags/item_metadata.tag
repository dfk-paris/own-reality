<or-item-metadata>
  
  <div>
    <h2>
      <or-content-localized-value value={opts.item._source.title} />
    </h2>
    <div class="or-subtitle" show={opts.item._type == 'chronology'}>
      {or.i18n.t('exhibition', {count: 1})} {or.i18n.t('in')}
      <or-attribute
        each={id in opts.item._source.attrs.ids[7][168]}
        key={id}
        shorten-to={100}
      />
    </div>

    <div class="or-metadata">
      <div class="or-field" each={role_id, people in opts.item._source.people} >
        <strong>
          {parent.or.i18n.l(parent.or.config.server.roles[role_id])}:
        </strong>
        <or-people-list people={people} />
      </div>

      <div class="or-field" show={opts.item._type == 'sources'}>
        <strong>{t('source', {count: 1})}:</strong>
        <or-journal-and-volume item={opts.item} />
      </div>
    </div>

    <div class="or-text" show={opts.item._type == 'sources'}>
      <div class="or-field">
        <or-content-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="clearfix" show={opts.item._type == 'sources'}></div>
    
    <div class="or-field">
      <strong>{t('keyword', {count: 'other'})}:</strong>
      <or-attribute-list keys={opts.item._source.attrs.ids[6][43]} />
    </div>

    <div class="or-field" show={opts.item._type == 'sources'}>
      <strong>{t('recommended_citation_style', {count: 1})}:</strong>
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
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      $(self.root).on 'click', 'or-attribute', (event) ->
        event.preventDefault()
        if window.confirm(self.or.i18n.t('confirm_replace_search'))
          key = $(event.target).parents('or-attribute').attr('key')
          self.or.cache_attributes([key])
          self.or.bus.trigger 'reset-search-with', attribs: [key]

    self.t = self.or.i18n.t
  </script>

</or-item-metadata>