$(document).ready -> riot.mount('*')

window.or = {
  config: {
    base_url: 'http://localhost:3000'
  }
  locale: -> document.location.href.match(/\/(\w\w)\//)[1]
  localize: (value) ->
    value[this.locale()] || 
      value[this.locales[0]] || value[this.locales[1]] || value[this.locales[2]]
  locales: ['fr', 'de', 'en']
  scroll_to: (selector) -> 
    console.log selector
    if element = $(selector)[0]
      console.log element
      element.scrollIntoView(true)
}