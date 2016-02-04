$(document).ready -> riot.mount('*')

window.or = {
  config: {
    api_url: 'http://localhost:3000'
  }
  locale: -> document.location.href.match(/\/(\w\w)\//)[1]
  localize: (value) ->
    value[this.locale()] || 
      value[this.locales[0]] || value[this.locales[1]] || value[this.locales[2]]
  locales: ['fr', 'de', 'en']
  scroll_to: (selector) -> 
    if element = $(selector)[0]
      element.scrollIntoView(true)
  filters: {
    limitTo: (value, chars = 30) ->
      if typeof value == 'string'
        if value.length > chars
          value.slice(0, chars) + '...'
        else
          value
      else
        value
  }
  bus: riot.observable()
}