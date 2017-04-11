wApp.i18n = {
  translations: {}
  locales: ['fr', 'de', 'en']
  locale: -> 
    wApp.routing.packed()['lang'] || 'de'
  translate: (locale, input, options = {}) ->
    try
      options.count ||= 1
      parts = input.split(".")
      result = wApp.i18n.translations[locale]
      
      for part in parts
        result = result[part]
      
      count = if options.count == 1 then 'one' else 'other'
      result = result[count] || result

      for key, value of options.values
        regex = new RegExp("%\{#{key}\}", "g")
        result = result.replace regex, value
      
      for key, value of options.interpolations
        regex = new RegExp("%\{#{key}\}", "g")
        tvalue = wApp.i18n.translate(locale, value)
        value = tvalue if tvalue && (tvalue != value)
        result = result.replace regex, value

      if options['capitalize']
        result = wApp.i18n.capitalize(result)
        
      result
    catch error
      console.log locale, input, options, error
      input
  capitalize: (string) -> string.charAt(0).toUpperCase() + string.slice(1)
  localize: (locale, input, format_name = 'default') ->
    try
      return "" unless input
      format = wApp.i18n.translate locale, "date.formats.#{format_name}"
      date = new Date(input)
      strftime(format, date)
    catch error
      console.log arguments
      console.log error
      ""
  lv: (value, options = {}) ->
    options['notify'] = true unless options['notify'] == false
    value[wApp.i18n.locale(options['content'])] ||
    value[wApp.i18n.locales[0]] || value[wApp.i18n.locales[1]] ||
    value[wApp.i18n.locales[2]] ||
    if options['notify'] then "*TRANSLATION MISSING*" else undefined
  humanSize: (input) ->
    if input < 1024
      return "#{input} B"
    if input < 1024 * 1024
      return "#{Math.round(input / 1024 * 100) / 100} KB"
    if input < 1024 * 1024 * 1024
      return "#{Math.round(input / (1024 * 1024) * 100) / 100} MB"
    if input < 1024 * 1024 * 1024 * 1024
      return "#{Math.round(input / (1024 * 1024 * 1024) * 100) / 100} GB"
}

wApp.mixins.i18n = {
  locale: wApp.i18n.locale
  lv: wApp.i18n.lv
  t: (input, options = {}) ->
    wApp.i18n.translate this.locale(), input, options
  tcap: (input, options = {}) ->
    options['capitalize'] = true
    wApp.i18n.translate this.locale(), input, options
  l: (input, format_name) ->
    wApp.i18n.localize this.locale(), input, format_name
  hs: (input) -> wApp.i18n.humanSize(input)

}

wApp.bus.on 'routing:query', ->
  l = wApp.routing.packed()['lang']
  if l && l != wApp.i18n.locale
    riot.update()
