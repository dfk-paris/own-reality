<or-people-list>
  <span>{list()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.list = ->
      results = for p in opts.people
        if p.first_name
          "#{p.first_name} #{p.last_name}"
        else
          p.last_name
      results.join(', ')
  </script>
</or-people-list>