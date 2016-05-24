(->
  ownreality.scroll_to = (selector) -> 
    if element = $(selector)[0]
      element.scrollIntoView(true)

  ownreality.compare = (x, y) ->
    if x > y
      1
    else if x == y
      0
    else
      -1

)()
