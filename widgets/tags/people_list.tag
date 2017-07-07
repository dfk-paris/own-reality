<or-people-list><!--

--><virtual if={opts.people}><!--
 --><span if={!as_buttons()}>{list()}</span><!--

 --><span if={as_buttons()} class="or-badge-list"><!--
   --><span each={person in sorted_people()} class="or-item-wrapper"><!--
     --><or-person person={person} onclick={clickPerson} class="or-item" /><!--
   --></span><!--
 --></span><!--
--></virtual><!--

--><script type="text/coffee">
    tag = this

    tag.as_buttons = -> tag.opts.asButtons
    tag.sorted_people = ->
      tag.opts.people.sort (x, y) ->
        if x.last_name < y.last_name
          -1
        else
          if x.last_name == y.last_name then 0 else 1
    tag.list = ->
      results = for p in tag.sorted_people()
        if p.first_name
          "#{p.first_name} #{p.last_name}"
        else
          p.last_name
      results.join(', ')

    tag.clickPerson = (event) ->
      h(event) if h = tag.opts.onClickPerson
  </script>
</or-people-list>