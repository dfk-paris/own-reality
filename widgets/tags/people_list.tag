<or-people-list>
  <span if={!as_buttons()}>{list()}</span>
  <span if={as_buttons()} class="or-list">
    <span each={person in sorted_people()} class="or-list-element">
      <or-person person={person} />
    </span>
  </span>

  <style type="text/scss">
    or-people-list {
      .or-list {
        line-height: 1.5rem;
        
        .or-list-element {
          padding-right: 0.2rem;

          or-person {
            font-size: 0.7rem;
            border-radius: 3px;
            padding: 0.2rem;
            background-color: darken(#ffffff, 20%);
            white-space: nowrap;
          }
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.as_buttons = -> self.opts.asButtons; true
    self.sorted_people = ->
      opts.people.sort (x, y) ->
        if x.last_name < y.last_name
          -1
        else
          if x.last_name == y.last_name then 0 else 1
    self.list = ->
      results = for p in self.sorted_people()
        if p.first_name
          "#{p.first_name} #{p.last_name}"
        else
          p.last_name
      results.join(', ')
  </script>
</or-people-list>