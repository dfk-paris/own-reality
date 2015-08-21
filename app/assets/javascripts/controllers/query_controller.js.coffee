app.controller "query_controller", [
  "$scope", "data_service", "wuBase64Location", "$location", "session_service",
  "attributes_service", "orMisc",
  (scope, ds, l, lo, ss, as, m) ->
    scope.ds = -> ds
    scope.debug = -> ss.debug
    scope.misc = -> m
    scope.locale = -> ss.locale

    window.s = scope

    scope.form = l.search("form") || {
      lower: 1961
      upper: 1980
      refs: []
    }

    query = ->
      ds.search(scope.form).success (search_data) ->
        console.log(search_data)
        
        as.for(search_data, scope.form).success (data) ->
          lookup = {}
          for i in data
            lookup[i._id] = i
          scope.lookup = lookup
          scope.results = search_data

    scope.$on "$routeChangeSuccess", query
    scope.$on "$routeUpdate", query

    urlUpdate = ->
      l.search "form", scope.form

    urlUpdateCurrent = ->
      l.search "current_id", scope.current_id

    scope.$watch "form", urlUpdate, true
    scope.$watch "current_id", urlUpdateCurrent

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

    scope.set_current_id = (record, event) ->
      event.preventDefault()
      scope.current_id = record._source.id

    scope.set_current_hash = (record, event) ->
      event.preventDefault()
      scope.current_document_hash = record._source.file_base_hash
]