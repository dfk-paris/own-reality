app.service "papers_service", [
  "$http",
  (http) ->
    service = {
      index: (type) ->
        http(
          method: "get"
          url: "/api/papers/#{type}"
        )
      show: (type, id) ->
        http(
          method: "get"
          url: "/api/papers/#{type}/#{id}"
        )
    }
]