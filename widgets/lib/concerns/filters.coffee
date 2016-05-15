(->
  ownreality.filters = {
    limitTo: (value, chars = 30) ->
      if typeof value == 'string'
        if value.length > chars
          value.slice(0, chars) + '...'
        else
          value
      else
        value
  }
)()
