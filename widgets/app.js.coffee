Zepto = Zepto || jQuery

Zepto.extend Zepto.ajaxSettings, {
  dataType: 'json'
  contentType: 'application/json'
}

# riot.util.tmpl.errorHandler = (err) ->
#   console.error(err, err.riotData)
  # console.error(err.message + ' in ' + err.riotData.tagName, err)

window.wApp = {
  bus: riot.observable()
  config: {}
  data: {}
  mixins: {}

  setup: ->
    wApp.config.api_url = wApp.api_url()

    miscPromise = Zepto.ajax(
      url: "#{wApp.config.api_url}/api/misc"
      success: (data) ->
        wApp.config.server = data
        Zepto('body').append('<w-modal>')
    )

    Zepto.when(miscPromise).then ->
      console.log 'app loaded, mounting'
      
      riot.mount('*')
      wApp.routing.setup()

  api_url: ->
    if document.location.href.match(/^https:\/\/ownreality\.dfkg\.\org/)
      'https://ownreality.dfkg.org'
    else if document.location.href.match(/^http:\/\/dfk-stage/)
      'https://ownreality.dfkg.org'
    else if document.location.href.match(/^https:\/\/dfk-paris/)
      'https://ownreality.dfkg.org'
    else
      $('script[or-api-url]').attr('or-api-url') || '' #'http://localhost:3000'
}
