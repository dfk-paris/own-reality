app.filter 't', [
  "orTranslate",
  (ot) ->
    filter = (input, options = {}) -> ot.translate(input, options)
    filter.$stateful = true
    filter
]
