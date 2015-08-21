app.service "attributes_service", [
  "$http",
  (http) ->
    service = {
      index: (ids) ->
        http(
          method: "post"
          url: "/api/entities/lookup",
          data: {ids: ids}
        )
      for: (data, form) ->
        ids = []
        if data.id_refs
          ids = ids.concat(data.id_refs || [])
        if data.aggregations
          for akey, aggregation of data.aggregations
            for bucket in aggregation.buckets
              ids.push(bucket.key)
        if form
          for ref in form.refs
            ids.push ref
        service.index(ids)
    }
]