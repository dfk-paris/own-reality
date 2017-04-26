<or-source>

  <div class="header">
    <div class="formats">
      <or-content-locale-selector item={opts.item} />
    </div>

    <div class="navigation">
      <a class="anchor" href="#or-article">{tcap('source')}</a>
      <a class="anchor" href="#or-summary">{tcap('summary')}</a>
      <a
        if={hasContent()}
        class="anchor"
        href="#or-content"
      >{tcap('content')}</a>
      <a class="anchor" href="#or-related-people">{tcap('people_involved')}</a>
      <a class="anchor" href="#or-attributes">{tcap('keyword', {count: 'other'})}</a>
      <a class="anchor" href="#or-citation">{tcap('recommended_citation_style')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <div class="or-main-section or-detail-section">
    <div class="or-metadata">
      <h1 name="or-article">{lcv(opts.item._source.title)}</h1>
      <or-people-list people={opts.item._source.people[12063]} />
      <div class="in">{t('in')}:</div>
      <or-journal-and-volume item={opts.item} />
      
      <div>IMAGE</div>
    </div>
  </div>

  <div class="or-detail-section">
    <div class="or-metadata">
      <h2 name="or-summary">{tcap('summary')}</h2>
      <p>{lcv(opts.item._source.interpretation)}</p>
    </div>
  </div>

  <div class="or-detail-section" if={hasContent()}>
    <div class="or-metadata">
      <h2 name="or-content">{tcap('content')}</h2>
      <p>{lcv(opts.item._source.content)}</p>
    </div>
  </div>

  <div class="or-detail-section">
    <div class="or-metadata">
      <h2 name="or-related-people">{lv(wApp.config.server.roles[12064])}</h2>
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
      <h2 name="or-attributes">{tcap('keyword', {count: 'other'})}</h2>
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
      <h2 name="or-citation">{tcap('recommended_citation_style', {count: 1})}</h2>
      <or-citation item={opts.item} />
    </div>
    <or-icon which="up" />
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.hasContent = ->
      tag.opts.item._source.content[tag.contentLocale()]

    tag.clickAttribute = (event) ->
      h(event) if h = tag.opts.handlers.clickAttribute

    tag.clickPerson = (role_id) ->
      (event) ->
        h(event) if h = tag.opts.handlers.clickPerson

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]

  </script>
</or-source>