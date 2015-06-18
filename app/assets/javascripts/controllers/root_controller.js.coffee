app.controller "root_controller", [
  "$scope", "data_service", "session_service", "wuBase64Location", "$location",
  (scope, ds, ss, l, lo) ->
    scope.debug = false

    scope.config = {
      locales: ds.locales
      locale: ss.locale
    }

    scope.form = l.search("form") || {
      lower: 1961
      upper: 1980
      refs: []
    }

    scope.$on "$routeChangeSuccess", -> query()
    scope.$on "$routeUpdate", ->
      console.log("querying", scope.form)
      query()

    query = ->
      ds.search(scope.form).success (search_data) ->
        console.log(search_data)
        ds.lookup_for(search_data, scope.form).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup
          scope.results = search_data

    urlUpdate = ->
      l.search "form", scope.form

    urlUpdateCurrent = ->
      l.search "current_id", scope.current_id

    scope.$watch "form", urlUpdate, true
    scope.$watch "current_id", urlUpdateCurrent
    scope.$watch "config.locale", (new_value) -> 
      ss.locale = new_value

    scope.add_ref = (key, event) ->
      event.preventDefault()
      scope.form.refs.push(key)

    scope.remove_ref = (key, event) ->
      event.preventDefault()
      i = scope.form.refs.indexOf(key)
      scope.form.refs.splice i, 1

    scope.file_url = (record, res = 140) ->
      if hash = record._source.file_base_hash
        if res == 'original'
          "files/#{hash}/original.pdf"
        else
          "files/#{hash}/#{res}.jpg"

    scope.author_list = (record) ->
      record._source.authors.join('; ')

    scope.bibliography = (record) ->
      "#{record._source.journal}, #{record._source.volume}"

    scope.shortcut = (event) ->
      if event.ctrlKey && event.altKey
        if event.which == 68
          scope.debug = !scope.debug

    scope.set_current_id = (record, event) ->
      event.preventDefault()
      scope.current_id = record._source.id

    window.l = l
    window.lo = lo
    window.s = scope
    window.ss = ss
]