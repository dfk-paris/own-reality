(->
  i18n = {
    locale: -> ownreality.config.locale
    locales: ['fr', 'de', 'en']
    translations: {}
    t: (input, options = {}) ->
      try
        options.count ||= 1
        parts = input.split(".")
        result = i18n.translations[i18n.locale()]

        for part in parts
          result = result[part]
        
        count = if options.count == 1 then 'one' else 'other'
        result = result[count] || result
        
        for key, value of options.ip
          regex = new RegExp("%\{#{key}\}", "g")
          tvalue = i18n.t(value)
          value = tvalue if tvalue && (tvalue != value)
          result = result.replace regex, value
          
        result
      catch error
        console.log error
        "*TRANSLATION MISSING*"
    l: (value, notify = true) ->
      value[ownreality.config.locale] || value[i18n.locales[0]] ||
      value[i18n.locales[1]] || value[i18n.locales[2]] ||
      if notify then "*TRANSLATION MISSING*" else undefined
    ld: (input, format_name = 'default') ->
      try
        date = new Date(Date.parse(input))
        format = i18n.t "date.formats.#{format_name}"
        result = new Strftime(date)
        result.render format
      catch error
        "DATE COULD NOT BE LOCALIZED: #{input}"
  }

  ownreality.i18n = i18n
)()
