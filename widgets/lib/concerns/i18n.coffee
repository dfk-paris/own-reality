(->
  i18n = {
    locale: (is_content) -> 
      if is_content then ownreality.config.clocale else ownreality.config.locale
    locales: ['fr', 'de', 'en']
    translations: {}
    t: (input, options = {}) ->
      try
        options.count ||= 1
        parts = input.split(".")
        result = i18n.translations[i18n.locale(options['content'])]

        for part in parts
          result = result[part]
        
        count = if options.count == 1 then 'one' else 'other'
        result = result[count] || result
        
        for key, value of options.ip
          regex = new RegExp("%\{#{key}\}", "g")
          tvalue = i18n.t(value)
          value = tvalue if tvalue && (tvalue != value)
          result = result.replace regex, value
          
        if options['capitalize'] then i18n.cap(result) else result
      catch error
        console.log error
        "*TRANSLATION MISSING*"
    cap: (string) ->
      string.charAt(0).toUpperCase() + string.slice(1)
    l: (value, options = {}) ->
      options['notify'] = true unless options['notify'] == false
      value[i18n.locale(options['content'])] || value[i18n.locales[0]] ||
      value[i18n.locales[1]] || value[i18n.locales[2]] ||
      if options['notify'] then "*TRANSLATION MISSING*" else undefined
    ld: (input, format_name = 'default') ->
      try
        date = new Date(Date.parse(input))
        format = i18n.t "date.formats.#{format_name}"
        func = strftime.localize(i18n.t 'date.names')
        func(format, date)
      catch error
        "DATE COULD NOT BE LOCALIZED: #{input}"
  }

  ownreality.i18n = i18n
)()
