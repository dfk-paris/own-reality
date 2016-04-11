<or-person>
  
  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.label = ->
      "#{self.opts.person.first_name} #{self.opts.person.last_name}"
  </script>

</or-person>