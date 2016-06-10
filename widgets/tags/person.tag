<or-person>
  
  <span data-person-id={opts.person.id} >{label()}</span>

  <script type="text/coffee">
    self = this

    self.on 'update', ->
      id = self.opts.personId
      self.opts.person = self.or.cache.people[id]
      self.update()

    # self.on 'mount', ->
    #   id = self.opts.personId
    #   self.opts.person = self.or.cache.people[id]
    #   self.update()

      # unless self.opts.person
      #   id = self.opts.personId
      #   if self.opts.person = self.or.cache.people[id]
      #     self.update()
      #   else
      #     $.ajax(
      #       type: 'post'
      #       url: "#{self.or.config.api_url}/api/entities/#{id}"
      #       data: {type: 'people'}
      #       success: (data) ->
      #         self.opts.person = data.docs[0]._source
      #         self.or.cache.people[id] = self.opts.person
      #         self.update()
      #     )

    self.label = ->
      result = if self.opts.person.first_name != null
        if self.opts.machine
          "#{self.opts.person.last_name}, #{self.opts.person.first_name}"
        else
          "#{self.opts.person.first_name} #{self.opts.person.last_name}"
      else
        self.opts.person.last_name

      if self.opts.limitTo
        self.or.i18n.limitTo(result, self.opts.limitTo)
      else
        result
  </script>

</or-person>