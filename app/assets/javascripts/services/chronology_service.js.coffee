app.service "chronology_service", [
  "$http",
  (http) ->
    service = {
      index: ->
        http(
          method: "post"
          url: "/api/chronology"
        )
    }
]