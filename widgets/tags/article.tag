<or-article>
  
  <div class="header no-print">
    <div class="formats">
      <a href="#" onclick={print}>
        <or-icon which="print" />
      </a>
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
        
        <div if={hasPDF()} class="or-perspectivia-ref">
          {t('perspectivia_ref')}
          <a href={perspectiviaLink()}>{perspectiviaLink()}</a>.
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
    window.t = tag

    tag.clickAttribute = (event) ->
      key = event.item.key
      h(key) if h = tag.opts.handlers.clickAttribute

    tag.clickPerson = (role_id) ->
      (event) ->
        key = event.item.person.id
        h(role_id, key) if h = tag.opts.handlers.clickPerson

    tag.hasPDF = ->
      !!tag.opts.item._source.pdfs[tag.contentLocale()]

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]

    tag.print = (event) ->
      event.preventDefault();
      wApp.utils.printElement(tag.root);

    tag.perspectiviaLink = ->
      m = wApp.config.server.perspectivia_link_map['articles'] || {}
      m[tag.opts.item._id] || "http://www.perspectivia.net/publikationen/ownreality"

  </script>
  
</or-article>