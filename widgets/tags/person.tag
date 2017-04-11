<or-person>
  
  <span
    if={person()}
    data-person-id={person().id}
  >{label()}</span>

  <script type="text/coffee">
    tag = this

    tag.person = ->
      tag.opts.person || personById(tag.opts.personId)

    personById = (id) ->
      people = wApp.cache.data.people
      if people && id
        people[id]
      else
        {}

    # tag.on 'mount', ->
    #   id = tag.opts.personId
    #   tag.opts.person = tag.or.cache.people[id]
    #   tag.update()

      # unless tag.opts.person
      #   id = tag.opts.personId
      #   if tag.opts.person = tag.or.cache.people[id]
      #     tag.update()
      #   else
      #     $.ajax(
      #       type: 'post'
      #       url: "#{tag.or.config.api_url}/api/entities/#{id}"
      #       data: {type: 'people'}
      #       success: (data) ->
      #         tag.opts.person = data.docs[0]._source
      #         tag.or.cache.people[id] = tag.opts.person
      #         tag.update()
      #     )

    tag.label = ->
      result = if tag.person().first_name != null
        if tag.opts.machine
          "#{tag.person().last_name}, #{tag.person().first_name}"
        else
          "#{tag.person().first_name} #{tag.person().last_name}"
      else
        tag.person().last_name

      if tag.opts.limitTo
        wApp.utils.limitTo(result, tag.opts.limitTo)
      else
        result
  </script>

</or-person>