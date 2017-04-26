wApp.cache = {
  data: {
    attrs: {}
    people: {}
    objects: {}
  }

  attributes: (ids) ->
    # console.log ids
    if ids
      missing_ids = ids.filter (id) -> !wApp.cache.data.attrs[id]
      $.ajax(
        type: 'POST'
        url: "#{wApp.api_url()}/api/entities/lookup"
        data: JSON.stringify(ids: missing_ids, type: 'attribs')
        success: (data) ->
          for a in data
            if a._source
              wApp.cache.data.attrs[a._source.id] = a._source
          riot.update()
      )

  people: (ids) ->
    # console.log ids
    if ids
      missing_ids = ids.filter (id) -> !wApp.cache.data.people[id]
      Zepto.ajax(
        type: 'POST'
        url: "#{wApp.api_url()}/api/entities/lookup"
        data: JSON.stringify(ids: missing_ids, type: 'people')
        success: (data) ->
          for a in data
            if a._source
              wApp.cache.data.people[a._source.id] = a._source
          riot.update()
      )

  objects: (type) ->
    d = {
      type: 'POST'
      url: "#{wApp.api_url()}/api/entities/search"
      data: JSON.stringify(
        type: type
        per_page: 100
      )
      error: -> console.log arguments
      success: (data) ->
        # console.log data
        wApp.cache.data.objects[type] = data.records
        wApp.cache.data.object_index ||= {}
        wApp.cache.data.object_index[type] ||= {}
        for r in data.records
          wApp.cache.data.object_index[type][r['_id']] = r
        wApp.bus.trigger 'object-data'
    }

    unless wApp.cache.data.objects[type]
      window.ata = d
      wApp.cache.data.objects[type] = Zepto.ajax(d)

}
