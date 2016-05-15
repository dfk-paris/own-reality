(->
  ownreality.scroll_to = (selector) -> 
    if element = $(selector)[0]
      element.scrollIntoView(true)
)()
