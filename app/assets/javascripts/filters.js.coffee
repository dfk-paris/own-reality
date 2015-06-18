app.filter 't', [
  "orTranslate",
  (ot) ->
    filter = (input, options = {}) -> ot.translate(input, options)
    filter.$stateful = true
    filter
]

app.filter 'people_list', [ ->
  (input) ->
    return null unless input

    results = []
    for person in input
      results.push "#{person.first_name} #{person.last_name}"
    results.join(', ')
]