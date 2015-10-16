app.service 'orTranslate', [
  "session_service", "orTranslations", "$filter",
  (ss, ts, f) ->
    service = {
      current_locale: -> ss.locale
      other_locale: -> if ss.locale == 'de' then 'fr' else 'de'
      capitalize: (string) -> 
        return "" unless typeof string is "string"
        string.charAt(0).toUpperCase() + string.slice(1)
      translate: (input, options = {}) ->
        result = ""

        try
          options.count ||= 1
          parts = input.split(".")
          result = ts[ss.locale]
          
          for part in parts
            result = result[part]
          
          count = if options.count == 1 then 'one' else 'other'
          result = result[count] || result

          for key, value of options.interpolations
            regex = new RegExp("%\{#{key}\}", "g")
            tvalue = this.translate(value, is_interpoliation: true)
            value = tvalue if (tvalue != "" && tvalue != value)
            result = result.replace regex, value

          result = service.capitalize(result) if options.capitalize
        catch error
          # console.log error

        if options.is_interpoliation
          result
        else
          result || "#{input} [TNF]"
      localize: (input, format_name = 'default') ->
        try
          input = new Date(Date.parse(input))
          format = service.translate "date.formats.#{format_name}"
          f("date")(input, format)
        catch error
          console.log(error)
          ""
      localize_with_imprecision: (input, imprecision = false) ->
        format_name = {"month": "hide_month", "day": "hide_day"}[imprecision] || 'default'
        format =  service.translate "date.formats.#{format_name}"
        if angular.isArray(input)
          if input[1]
            from = service.localize(input[0], format_name)
            to = service.localize(input[1], format_name)
            "#{from} - #{to}"
          else
            if date = input[0] || input[1]
              service.localize(date)
        else
          service.localize(input, format_name)
      has_value: (object) ->
        return false unless object
        object[service.current_locale()] || object[service.other_locale()]

    }
]