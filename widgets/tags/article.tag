<or-article>
  
  <div class="header">
    <or-icon which="close" onclick={onClickClose} />

    <div class="formats">
      <a href="#"><or-icon which="doc" /></a>
      <a href="#"><or-icon which="print" /></a>

      <div class="language-selector" if={opts.item}>
        <a
          each={lang in ['de', 'fr', 'en', 'pl']}
          class={active: contentLocale() == lang}
          if={opts.item._source.title[lang]}
          onclick={switchContentLocale(lang)}
        >{t(lang)}</a>
      </div>
    </div>
    <div class="navigation">
      <a class="anchor" href="#or-article">{t('article')}</a>
      <a class="anchor" href="#or-related-people">{t('people_involved')}</a>
      <a class="anchor" href="#or-attributes">{t('keyword', {count: 'other'})}</a>
      <a class="anchor" href="#or-citation">{t('recommended_citation_style')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <virtual if={opts.item}>
    <or-paper if={opts.item._type == 'articles'} item={opts.item} />

    <div class="or-related-people" each={people, role_id in opts.item._source.people}>
      <div class="or-metadata">
        <h2 name="or-related-people">{lv(wApp.config.server.roles[role_id])}</h2>
        <p>
          <or-people-list
            people={people}
            as-buttons={true}
            on-click-person={clickPerson(role_id)}
          />
        </p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-attributes">
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

    <div class="or-citation">
      <div class="or-metadata">
        <h2>{t('recommended_citation_style', {count: 1, capitalize: true})}</h2>
        <or-citation item={opts.item} />
      </div>
      <or-icon which="up" />
    </div>
  </virtual>


  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      Zepto(tag.root).on 'click', 'or-icon[which=up] svg', (event) ->
        event.preventDefault()
        wApp.utils.scrollTo Zepto('body'), Zepto('.receiver')

      Zepto(tag.root).on 'click', "a.suite, a.tonote, a.noteNum, a.tosub, a.anchor", (event) ->
        event.preventDefault()
        anchor = Zepto(event.currentTarget).attr('href').replace('#', '')
        wApp.utils.scrollTo Zepto("[name=#{anchor}], anchor[id=#{anchor}]"), Zepto('.receiver')

      if tag.opts.item
        tag.cache.attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{wApp.config.api_url}/api/items/articles/#{tag.opts.id}"
          success: (data) ->
            # console.log data
            tag.opts.item = data.docs[0]
            tag.cache_attributes()
            tag.update()
        )

    tag.clickAttribute = (event) ->
      event.preventDefault()
      key = event.item.key
      $(tag.root).on 'click', 'or-attribute', (event) ->
        if window.confirm(tag.t('confirm_replace_search'))
          wApp.bus.trigger 'close-modal'
          wApp.bus.trigger 'reset-search-with', attribs: [key]

    tag.clickPerson = (role_id) ->
      (event) ->
        event.preventDefault()
        if window.confirm(tag.t('confirm_replace_search'))
          key = event.item.person.id
          data = {people: {}}
          data.people[role_id] = [key]
          wApp.bus.trigger 'close-modal'
          wApp.bus.trigger 'reset-search-with', data

    tag.cache_attributes = ->
      try
        wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e

    tag.onClickClose = -> wApp.bus.trigger 'close-modal'

    tag.switchContentLocale = (lang) ->
      (event) ->
        event.preventDefault()
        console.log lang
        wApp.routing.packed(cl: lang)

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]
  </script>
  
</or-article>