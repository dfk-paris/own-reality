(->
  ownreality.routing = {
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
  }

  riot.route '..', () ->
    # console.log arguments
    # console.log riot.route.query()

    if lang = riot.route.query()['lang']
      if lang != ownreality.config.locale
        ownreality.config.locale = lang
        riot.update()

    if modal = riot.route.query()['modal']
      tag = riot.route.query()['tag']
      id = riot.route.query()['id']
      ownreality.bus.trigger 'modal', tag, id: id

  riot.route.start true
)()
