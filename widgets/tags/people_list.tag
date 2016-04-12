<or-people-list>
  <span>{list()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.list = ->
      ("#{p.first_name} #{p.last_name}" for p in opts.people).join(', ')    
  </script>
</or-people-list>