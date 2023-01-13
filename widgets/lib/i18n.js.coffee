wApp.i18n = {
  translations: {}
  locales: ['fr', 'de', 'en']
  locale: -> 
    wApp.i18n.currentLocale = 
      wApp.routing.packed()['lang'] ||
      (document.location.href.match(/^https?:\/\/[^\/]+\/([a-z]{2})\//) || [])[1] ||
      'de'
  contentLocale: ->
    wApp.i18n.currentContentLocale = 
      wApp.routing.packed()['cl'] || wApp.i18n.locale()
  translate: (locale, input, options = {}) ->
    # console.log(arguments)

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
      wApp.i18n.localizedStrftime ||= {
        'de': strftime.localizeByIdentifier('de_DE')
        'fr': strftime.localizeByIdentifier('fr_FR')
        'en': strftime.localizeByIdentifier('en_US')
      }
      wApp.i18n.localizedStrftime[locale](format, date)
    catch error
      console.log arguments
      console.log error
      ""
  lv: (value, options = {}) ->
    options['notify'] = true unless options['notify'] == false
    options['locale'] ||= wApp.i18n.locale()
    result = value[options['locale']] ||
      value[wApp.i18n.locales[0]] ||
      value[wApp.i18n.locales[1]] ||
      value[wApp.i18n.locales[2]] ||
      if options['notify'] then "*TRANSLATION MISSING*" else undefined
    if options['capitalize']
        result = wApp.i18n.capitalize(result)
    result
  lcv: (value, options = {}) ->
    options['locale'] = wApp.i18n.contentLocale()
    wApp.i18n.lv value, options
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
  contentLocale: wApp.i18n.contentLocale
  lv: wApp.i18n.lv
  lvcap: (value, options = {}) ->
    options['capitalize'] = true
    wApp.i18n.lv value, options
  lcv: wApp.i18n.lcv
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
  changes = (wApp.i18n.currentLocale != wApp.routing.packed()['lang'])
  changes ||= (wApp.i18n.currentContentLocale != wApp.routing.packed()['cl'])
  riot.update() if changes
