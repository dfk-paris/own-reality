<or-person>
  
  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.label = ->
      if self.opts.person.first_name != null
        "#{self.opts.person.first_name} #{self.opts.person.last_name}"
      else
        self.opts.person.last_name
  </script>

</or-person>