app.service "chronology_service", [
  "$http",
  (http) ->
    service = {
      index: (params = {}) ->
        http(
          method: "post"
          url: "/api/chronology"
          data: params
        )
    }
]