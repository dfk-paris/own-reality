<or-person>
  
  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      unless self.opts.person
        id = self.opts.personId
        if self.opts.person = self.or.cache.people[id]
          self.update()
        else
          $.ajax(
            type: 'post'
            url: "#{self.or.config.api_url}/api/entities/#{id}"
            data: {type: 'people'}
            success: (data) ->
              self.opts.person = data.docs[0]._source
              self.or.cache.people[id] = self.opts.person
              self.update()
          )

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