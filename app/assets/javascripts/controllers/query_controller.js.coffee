app.controller "query_controller", [
  "$scope", "$state", "data_service", "wuBase64Location", "session_service",
  "attributes_service", "orMisc", "wuListing"
  (scope, state, ds, l, ss, as, m, li) ->
    scope.ds = -> ds
    scope.debug = -> ss.debug
    scope.misc = -> m
    scope.locale = -> ss.locale

    scope.main = li.build(scope, "main", {
      default_filters: {
        lower: 1961
        upper: 1980
        refs: []
      },
      query: ->
        ds.search(scope.main.query_params()).success (search_data) ->
          console.log "R", search_data
          as.for(search_data, scope.main.query_params().filters).success (data) ->
            console.log "A", data
            lookup = {}
            for i in data
              lookup[i._id] = i
            scope.lookup = lookup

            scope.main.results = search_data
            scope.main.total = search_data.total
    })

    scope.add_ref = (key, event) ->
      event.preventDefault()
      scope.main.filters.refs.push(key)

    scope.remove_ref = (key, event) ->
      event.preventDefault()
      i = scope.main.filters.refs.indexOf(key)
      scope.main.filters.refs.splice i, 1

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