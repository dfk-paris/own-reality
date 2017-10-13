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
      <a class="anchor" href="#or-related-people">{tcap('person', {count: 'other'})}</a>
      <a class="anchor" href="#or-attributes">{tcap('keyword', {count: 'other'})}</a>
      <a class="anchor" href="#or-citation">{tcap('recommended_citation_style')}</a>
      <a class="anchor" href="#or-license">{tcap('license')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <virtual if={opts.item}>
    <div class="or-main-section or-detail-section">
      <div class="or-metadata">
        <h1 name="or-article">{lcv(opts.item._source.title)}</h1>
        <or-people-list people={opts.item._source.people[12063]} />
        <div class="in">{t('in')}:</div>
        <or-journal-and-volume item={opts.item} />
        
        <div if={hasImage()} class="or-medium">
          <div class="or-image">
            <img if={linkType() == null && !localRequest()} src={scanBlurredUrl()} />
            <a if={linkType() != null || localRequest()} target="_blank" href={scanOriginalUrl()}>
              <img src={scanUrl()} />
            </a>
          </div>
          <div class="or-caption">
            <span if={linkType() == null}>
              <span class="no-copyright-target"></span>
            </span>
            <span if={linkType() == 'link'}>
              {tcap('link_available')}
              <a target="_blank" href={linkUrl()}>{linkUrl()}</a>
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-summary">{tcap('summary')}</h2>
        <p>{lcv(opts.item._source.interpretation)}</p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section" if={hasContent()}>
      <div class="or-metadata">
        <h2 name="or-content">{tcap('content')}</h2>
        <p>{lcv(opts.item._source.content)}</p>
      </div>
      <or-icon which="up" />
    </div>

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

    tag.on 'updated', ->
      Zepto('.no-copyright-target').html(tag.tcap('no_copyright'))

    tag.hasContent = ->
      tag.opts.item._source.content[tag.contentLocale()]

    tag.clickAttribute = (event) ->
      key = event.item.key
      h(key) if h = tag.opts.handlers.clickAttribute

    tag.clickPerson = (role_id) ->
      (event) ->
        key = event.item.person.id
        h(role_id, key) if h = tag.opts.handlers.clickPerson

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]

    tag.hasImage = -> !!opts.item._source.file_base_hash

    tag.linkType = ->
      l = opts.item._source.scan_copyright
      if l && l.match(/^http/) then 'link' else null

    tag.linkUrl = ->
      if tag.linkType() == 'link' then opts.item._source.scan_copyright else null

    tag.scanUrl = -> 
      hash = tag.opts.item._source.file_base_hash
      "#{wApp.api_url()}/files/#{hash}/800.jpg"

    tag.scanBlurredUrl = -> 
      hash = tag.opts.item._source.file_base_hash
      "#{wApp.api_url()}/files/#{hash}/blurred.jpg"

    tag.scanOriginalUrl = ->
      hash = tag.opts.item._source.file_base_hash
      "#{wApp.api_url()}/files/#{hash}/original.pdf"

    tag.localRequest = ->
      !tag.opts.item.external_request

  </script>
</or-source>