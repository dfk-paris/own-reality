<or-person>
  
  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.label = ->
      result = if self.opts.person.first_name != null
        "#{self.opts.person.first_name} #{self.opts.person.last_name}"
      else
        self.opts.person.last_name

      if self.opts.limitTo
        self.or.filters.limitTo(result, self.opts.limitTo)
      else
        result
  </script>

</or-person>