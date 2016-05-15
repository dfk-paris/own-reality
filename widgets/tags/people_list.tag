<or-people-list>
  <span>{list()}</span>

  <script type="text/coffee">
    self = this
    

    self.list = ->
      sorted_people = opts.people.sort (x, y) ->
        if x.last_name < y.last_name
          -1
        else
          if x.last_name == y.last_name then 0 else 1
      results = for p in sorted_people
        if p.first_name
          "#{p.first_name} #{p.last_name}"
        else
          p.last_name
      results.join(', ')
  </script>
</or-people-list>