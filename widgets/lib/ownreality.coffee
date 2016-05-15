ownreality = {
  cache: {
    attrs: {}
    people: {}
  }
  data: {
    results: []
    aggregations: {}
  }
  config: {
    api_url: $('script[or-api-url]').attr('or-api-url') || 'http://localhost:3000'
    locale: 'de'
  }
  translations: {}
  bus: riot.observable()

  init: ->
    $(document).ready ->
      $('body').append('<or-modal>')
      riot.mount('*')

    $.ajax(
      type: 'GET'
      url: "#{ownreality.config.api_url}/api/misc"
      success: (data) -> ownreality.config.server = data
    )
}
