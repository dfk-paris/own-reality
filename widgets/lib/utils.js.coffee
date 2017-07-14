wApp.utils = {
  shorten: (str, n = 30) ->
    if str && str.length > n
      str.substr(0, n - 1) + '…'
    else
      str
  in_groups_of: (per_row, array, dummy = null) ->
    result = []
    current = []
    for i in array
      if current.length == per_row
        result.push(current)
        current = []
      current.push(i)
    if current.length > 0
      if dummy
        while current.length < per_row
          current.push(dummy)
      result.push(current)
    result
  to_integer: (value) ->
    if Zepto.isNumeric(value)
      parseInt(value)
    else
      value
  # TODO: remove this:
  scroll_to: (selector) -> 
    if element = $(selector)[0]
      element.scrollIntoView(true)
  scrollTo: (element, ref = window) ->
      y = Zepto(element)[0].offsetTop
      ref.scrollTop y
  compare: (x, y) ->
    if x > y
      1
    else if x == y
      0
    else
      -1
  range_label: (item) ->
    from = wApp.i18n.localize wApp.i18n.locale(), item._source.from_date
    to = wApp.i18n.localize wApp.i18n.locale(), item._source.to_date
    if from == to
      from
    else
      "#{from} – #{to}"
}
