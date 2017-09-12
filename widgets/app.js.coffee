Zepto = Zepto || jQuery

Zepto.extend Zepto.ajaxSettings, {
  dataType: 'json'
  contentType: 'application/json; charset=utf-8'
}

window.wApp = {
  bus: riot.observable()
  config: {}
  data: {}
  mixins: {}

  setup: ->
    miscPromise = Zepto.ajax(
      url: "#{wApp.api_url()}/api/misc"
      success: (data) ->
        wApp.config.server = data
        Zepto('body').append('<w-modal>')
    )

    Zepto.when(miscPromise).then ->
      riot.mount('*')
      wApp.routing.setup()

  api_url: ->
    setting = Zepto('script[or-api-url]').attr('or-api-url')
    setting || 'http://localhost:3000'

  searchUrl: ->
    setting = Zepto('script[or-search-url]').attr('or-search-url')
    setting || 'http://localhost:3000'
}
