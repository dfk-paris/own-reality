<or-content-locale-selector>

  <virtual if={opts.item}>
    <a
      each={lang in ['de', 'fr', 'en', 'pl']}
      class={active: isActive(lang)}
      if={opts.item._source.title[lang]}
      onclick={switchContentLocale(lang)}
    >{t(lang)}</a>
  </virtual>
      
  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.switchContentLocale = (lang) ->
      (event) ->
        event.preventDefault()
        wApp.routing.packed(cl: lang)

    tag.contentLocaleWithFallback = ->
      dataHasLocale = !!opts.item._source.title[tag.contentLocale()]
      if dataHasLocale
        tag.contentLocale()
      else
        for l in ['fr', 'de', 'en', 'pl']
          return l if !!opts.item._source.title[l]

    tag.isActive = (lang) ->
      tag.contentLocaleWithFallback() == lang

  </script>

</or-content-locale-selector>