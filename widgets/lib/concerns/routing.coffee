(->
  ownreality.routing = {
    path_query: ->
      str = document.location.href.match(/\?([^#]+)/)[1] || ''
      results = {}
      for pair in str.split('&')
        split = pair.split('=')
        results[split[0]] = split[1]
      results
    query: (params) ->
      if params
        result = {}
        $.extend(result, riot.route.query(), params)

        qs = []
        for k, v of result
          if result[k] != null
            qs.push "#{k}=#{v}"

        riot.route "#{ownreality.routing.path()}?#{qs.join '&'}"
      else
        riot.route.query()
    path: ->
      if m = document.location.hash.match(/^\#([^\?]*)/)
        m[1]
      else
        '/'
    set_packed: (values = {}) ->
      unpacked = self.ownreality.routing.unpack()
      for k, v of values
        if v then unpacked[k] = v else delete unpacked[k]
      ownreality.routing.pack(unpacked)
    pack_to_string: (unpacked = null) ->
      if unpacked
        btoa(JSON.stringify(unpacked))
    pack: (unpacked = {}) ->
      if unpacked != {}
        ownreality.routing.query(
          'q': ownreality.routing.pack_to_string(unpacked)
        )
      else
        ownreality.routing.query 'q': null
    unpack: ->
      packed = ownreality.routing.query()['q']
      if packed
        JSON.parse(atob(packed))
      else
        {}
  }

  riot.route '..', () ->
    # console.log arguments
    # console.log riot.route.query()

    if lang = riot.route.query()['lang']
      if lang != ownreality.config.locale
        ownreality.config.locale = lang
        ownreality.bus.trigger 'locale-change'
        riot.update()

    if clang = riot.route.query()['clang']
      if clang != ownreality.config.clocale
        ownreality.config.clocale = clang
        ownreality.bus.trigger 'content-locale-change'
        riot.update()

    if modal = riot.route.query()['modal']
      tag = riot.route.query()['tag']
      id = riot.route.query()['id']
      ownreality.bus.trigger 'modal', tag, id: id

    # if initial = riot.route.query()['initial']
    #   ownreality.bus.trigger 'register-initial-select', initial

    if riot.route.query()['q']
      console.log 'packed data', ownreality.routing.unpack()
      ownreality.bus.trigger 'packed-data', ownreality.routing.unpack()
      

  riot.route.start true
)()
