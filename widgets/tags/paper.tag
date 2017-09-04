<or-paper>

  <virtual if={opts.item}>
    <or-icon which="close" onclick={onClickClose} />
    <or-icon if={searchContext()} which="previous" onclick={onPrevious} />
    <or-icon if={searchContext()} which="next" onclick={onNext} />

    <or-article
      item={opts.item}
      if={opts.item._type == 'articles'}
      handlers={handlers}
    />

    <or-interview
      item={opts.item}
      if={opts.item._type == 'interviews'}
      handlers={handlers}
    />

    <or-magazine
      item={opts.item}
      if={opts.item._type == 'magazines'}
      handlers={handlers}
    />

    <or-source
      item={opts.item}
      if={opts.item._type == 'sources'}
      handlers={handlers}
    />

    <or-chronology
      item={opts.item}
      if={opts.item._type == 'chronology'}
      handlers={handlers}
    ></or-chronology>
  </virtual>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      fetch()
      registerUpEvent()
      fixAnchors()
      tag.handlers = {
        clickAttribute: clickAttribute
        clickPerson: clickPerson
      }

    tag.on 'updated', -> fixPagerPositions()

    clickAttribute = (key) ->
      if tag.searchContext()
        if window.confirm(tag.t('confirm_replace_search'))
          wApp.bus.trigger 'close-modal'
          wApp.bus.trigger 'reset-search-with', attribs: [key]
      else
        q = wApp.routing.pack({attribs: [key]})
        document.location.href = wApp.searchUrl() + '#/?q=' + q

    clickPerson = (role_id, key) ->
      if tag.searchContext()
        if window.confirm(tag.t('confirm_replace_search'))
          data = {people: {}}
          data.people[role_id] = [key]
          wApp.bus.trigger 'close-modal'
          wApp.bus.trigger 'reset-search-with', data
      else
        params = {people: {}}
        params.people[role_id] = [key]
        q = wApp.routing.pack(params)
        document.location.href = wApp.searchUrl() + '#/?q=' + q

    tag.onClickClose = -> wApp.bus.trigger 'close-modal'

    tag.onPrevious = -> wApp.bus.trigger 'previous-result', opts.item._id
    tag.onNext = -> wApp.bus.trigger 'next-result', opts.item._id

    tag.searchContext = -> !!wApp.searchContext

    fixAnchors = ->
      Zepto(tag.root).on 'click', "a.suite, a.tonote, a.noteNum, a.tosub, a.anchor", (event) ->
        event.preventDefault()
        anchor = Zepto(event.currentTarget).attr('href').replace('#', '')
        wApp.utils.scrollTo Zepto("[name=#{anchor}], anchor[id=#{anchor}]"), Zepto('.receiver')

    registerUpEvent = ->
      Zepto(tag.root).on 'click', 'or-icon[which=up] svg', (event) ->
        event.preventDefault()
        wApp.utils.scrollTo Zepto('body'), Zepto('.receiver')

    fetch = ->
      Zepto.ajax(
        url: "#{wApp.api_url()}/api/items/#{tag.opts.type}/#{tag.opts.id}"
        success: (data) ->
          tag.opts.item = data.docs[0]
          cacheAttributes()
          tag.update()
      )

    cacheAttributes = ->
      try
        wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])

        if gr = tag.opts.item._source.attrs.ids[7]
          wApp.cache.attributes(gr[168])
      catch e
        console.log e

    fixPagerPositions = ->
      targetElement = Zepto('.or-main-section, or-doc')
      if targetElement.length > 0
        target = targetElement.position().top
        Zepto('or-icon[which=next]').css 'top', target
        Zepto('or-icon[which=previous]').css 'top', target
  </script>

</or-paper>