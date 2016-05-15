<or-source>
  <div>
    <or-language-selector locales={['de', 'fr']} />

    <h2>
      <or-localized-value value={opts.item._source.title} />
    </h2>

    <div class="or-metadata">
      <div class="or-field" each={role_id, people in opts.item._source.people} >
        <strong>
          {parent.or.i18n.l(parent.or.config.server.roles[role_id])}:
        </strong>
        <or-people-list people={people} />
      </div>

      <div class="or-field">
        <strong>{t('source', {count: 1})}:</strong>
        <or-journal-and-volume item={opts.item} />
      </div>
    </div>

    <div class="or-text">
      <div class="or-field">
        <or-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="clearfix"></div>
    
    <div class="or-field">
      <strong>{t('keyword', {count: 'other'})}:</strong>
      <or-attribute-list keys={opts.item._source.attrs.ids[6][43]} />
    </div>

    <div class="or-field">
      <strong>{t('recommended_citation_style', {count: 1})}:</strong>
      <or-citation item={opts.item} />
    </div>
  </div>

  <style type="text/scss">
    or-source, [riot-tag=or-source] {
      padding: 1rem;
      height: 500px;
      overflow: scroll;

      h2 {
        margin-bottom: 1.5rem;
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

      or-language-selector {
        display: block;
        float: right;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    

    self.on 'mount', ->
      if self.opts.item
        self.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{self.or.config.api_url}/api/items/sources/#{self.opts.id}"
          success: (data) ->
            # console.log data
            self.opts.item = data.docs[0]
            self.cache_attributes()
            self.update()
        )

    self.cache_attributes = ->
      self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])

    self.t = self.or.i18n.t
  </script>
</or-source>