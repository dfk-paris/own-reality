(->
  ownreality.cache_attributes = (ids) ->
    # console.log ids
    if ids
      missing_ids = ids.filter (id) -> !ownreality.cache.attrs[id]
      $.ajax(
        type: 'POST'
        url: "#{ownreality.config.api_url}/api/entities/lookup"
        data: {ids: missing_ids, type: 'attribs'}
        success: (data) ->
          # console.log data
          for a in data
            if a._source
              ownreality.cache.attrs[a._source.id] = a._source
          riot.update()
      )

  ownreality.cache_people = (ids) ->
    # console.log ids
    if ids
      missing_ids = ids.filter (id) -> !ownreality.cache.people[id]
      $.ajax(
        type: 'POST'
        url: "#{ownreality.config.api_url}/api/entities/lookup"
        data: {ids: missing_ids, type: 'people'}
        success: (data) ->
          # console.log data
          for a in data
            if a._source
              ownreality.cache.people[a._source.id] = a._source
          riot.update()
      )
)()
