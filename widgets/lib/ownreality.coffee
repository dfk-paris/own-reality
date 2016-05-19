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
    api_url: (->
      if document.location.href.match(/^https:\/\/ownreality\.dfkg\.\org/)
        'https://ownreality.dfkg.org'
      else if document.location.href.match(/^http:\/\/dfk-stage/)
        'https://ownreality.dfkg.org'
      else if document.location.href.match(/^https:\/\/dfk-paris/)
        'https://ownreality.dfkg.org'
      else
        $('script[or-api-url]').attr('or-api-url') || 'http://localhost:3000'
    )()
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
