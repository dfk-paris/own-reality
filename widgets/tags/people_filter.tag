<or-people-filter>

  <span>
    <strong>{or.filters.t('person', {count: 'other'})}</strong>
    <input type="text" name="terms" />

    <div class="selection">
      <span class="item" data-id={person.id} each={person in people}>
        <or-person person={person} />
      </span>
    </div>
  </span>

  <style type="text/scss">
    or-people-filter {
      strong {
        display: block;
      }

      .selection {
        padding: 0.5rem;
      }

      .item {
        cursor: pointer;
        font-size: 0.7rem;
        border-radius: 3px;
        padding: 0.2rem;
        background-color: darken(#ffffff, 20%);
        white-space: nowrap;
        display: inline-block;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or
    self.people = []

    self.on 'mount', ->
      $(self.terms).autocomplete(
        source: (request, response) ->
          $.ajax(
            type: 'POST'
            url: "#{self.or.config.api_url}/api/people"
            data: {terms: request.term}
            success: (data) ->
              # console.log 'people:', data
              results = for person in data.records
                {
                  label: "#{person._source.first_name} #{person._source.last_name}",
                  value: person._source.id,
                  person: person._source
                }
              response(results)
          )
        focus: (event, ui) ->
          event.preventDefault()
        select: (event, ui) ->
          event.preventDefault()
          self.people.push ui.item.person
          $(event.target).val(null)
          self.notify()
      )

      $(self.root).on 'click', '.item', (event) ->
        event.preventDefault()
        id = parseInt($(event.currentTarget).attr('data-id'))
        item = null
        for i in self.people
          item = i if i.id == id
        index = self.people.indexOf(item)
        if index != -1
          self.people.splice(index, 1)
        self.notify()

    self.notify = ->
      self.update()
      self.or.bus.trigger 'people-filter', self.people

  </script>

</or-people-filter>