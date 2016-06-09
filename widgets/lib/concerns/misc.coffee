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

  ownreality.range_label = (item) ->
      from = ownreality.i18n.ld(item._source.from_date)
      to = ownreality.i18n.ld(item._source.to_date)
      if from == to
        from
      else
        "#{from} – #{to}"
)()
