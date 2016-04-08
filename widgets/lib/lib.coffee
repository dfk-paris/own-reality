$(document).ready -> riot.mount('*')

(->
  app = {
    cache: {
      attr_lookup: {}
    }
    data: {
      results: []
      aggregations: {}
    }
    config: {
      api_url: 'http://localhost:3000'
      # api_url: 'https://ownreality.dfkg.org'
      locale: 'fr'
    }
    locale: -> app.config.locale
    locales: ['fr', 'de', 'en']
    scroll_to: (selector) -> 
      if element = $(selector)[0]
        element.scrollIntoView(true)
    translations: {}
    route: {
      query: (params) ->
        if params
          result = {}
          $.extend(result, riot.route.query(), params)

          qs = []
          for k, v of result
            if result[k] != null
              qs.push "#{k}=#{v}"

          riot.route "#{app.route.path()}?#{qs.join '&'}"
        else
          riot.route.query()
      path: ->
        if m = document.location.hash.match(/^\#([^\?]*)/)
          m[1]
        else
          '/'
    }
    filters: {
      t: (input, options = {}) ->
        try
          options.count ||= 1
          parts = input.split(".")
          result = app.translations[app.locale()]

          for part in parts
            result = result[part]
          
          count = if options.count == 1 then 'one' else 'other'
          result = result[count] || result
          
          for key, value of options.ip
            regex = new RegExp("%\{#{key}\}", "g")
            tvalue = this.t(value)
            value = tvalue if tvalue && (tvalue != value)
            result = result.replace regex, value
            
          result
        catch error
          # console.log error
          "*TRANSLATION MISSING*"
      l: (value) ->
        value[app.config.locale] || value[app.locales[0]] ||
        value[app.locales[1]] || value[app.locales[2]] ||
        "*TRANSLATION MISSING*"
      # l: (input, format_name = 'default') ->
      #   try
      #     format = app.filters.t "date.formats.#{format_name}"
      #     result = new FormattedDate(input)
      #     result.strftime format
      #   catch error
      #     ""
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

  $.ajax(
    type: 'GET'
    url: "#{app.config.api_url}/api/misc"
    success: (data) -> app.config.server = data
  )

  riot.route '..', () ->
    console.log arguments
    console.log riot.route.query()

    if lang = riot.route.query()['lang']
      if lang != app.config.locale
        app.config.locale = lang
        riot.update()

  riot.route.start true

  window.or = app;
)();
