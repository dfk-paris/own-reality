<or-article>
  
  <div class="header">
    <div class="formats">
      <or-content-locale-selector item={opts.item} />
    </div>

    <div class="navigation">
      <a class="anchor" href="#or-article">{tcap('article')}</a>
      <a class="anchor" href="#or-related-people">{tcap('person', {count: 'other'})}</a>
      <a class="anchor" href="#or-attributes">{tcap('keyword', {count: 'other'})}</a>
      <a class="anchor" href="#or-citation">{tcap('recommended_citation_style')}</a>
      <a class="anchor" href="#or-license">{tcap('license')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <virtual if={opts.item}>
    <or-doc item={opts.item} />

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-related-people">{lvcap(wApp.config.server.plural_roles[12064])}</h2>
        <p>
          <or-people-list
            people={opts.item._source.people[12064]}
            as-buttons={true}
            on-click-person={clickPerson(12064)}
          />
        </p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-attributes">{t('keyword', {count: 'other', capitalize: true})}</h2>
        <p>
          <or-attribute-list
            keys={attrs(6, 43)}
            on-click-attribute={clickAttribute}
          />
        </p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-citation">{t('recommended_citation_style', {count: 1, capitalize: true})}</h2>
        <or-citation item={opts.item} />
        
        <div class="or-perspectivia-ref">
          {t('perspectivia_ref')}
          <a
            href="http://www.perspectivia.net/publikationen/ownreality">
            http://www.perspectivia.net/publikationen/ownreality</a
          >.
        </div>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-license">{tcap('license')}</h2>
        <or-license />
      </div>
      <or-icon which="up" />
    </div>
  </virtual>


  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.clickAttribute = (event) ->
      h(event) if h = tag.opts.handlers.clickAttribute

    tag.clickPerson = (role_id) ->
      (event) ->
        h(event) if h = tag.opts.handlers.clickPerson

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]
  </script>
  
</or-article>