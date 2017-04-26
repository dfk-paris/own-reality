<or-paper>

  <virtual if={opts.item}>
    <or-icon which="close" onclick={onClickClose} />

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

    clickAttribute = (event) ->
      event.preventDefault()
      if window.confirm(tag.t('confirm_replace_search'))
        key = event.item.key
        wApp.bus.trigger 'close-modal'
        wApp.bus.trigger 'reset-search-with', attribs: [key]

    clickPerson = (role_id) ->
      (event) ->
        event.preventDefault()
        if window.confirm(tag.t('confirm_replace_search'))
          key = event.item.person.id
          data = {people: {}}
          data.people[role_id] = [key]
          wApp.bus.trigger 'close-modal'
          wApp.bus.trigger 'reset-search-with', data

    tag.onClickClose = -> wApp.bus.trigger 'close-modal'

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
        url: "#{wApp.api_url()}/api/items/#{tag.opts.id}"
        success: (data) ->
          tag.opts.item = data.docs[0]
          cacheAttributes()
          tag.update()
      )

    cacheAttributes = ->
      try
        wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e
  </script>

</or-paper>