<or-journals-filter>

  <span>
    <strong>{or.filters.t('magazine', {count: 'other'})}</strong>
    <input type="text" name="terms" />

    <div class="selection">
      <span class="item" data-id={journal.id} each={journal in journals}>
        {or.filters.limitTo(or.filters.l(journal.title))}
      </span>
    </div>
  </span>

  <style type="text/scss">
    or-journals-filter {
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
    self.journals = []

    self.on 'mount', ->
      $(self.terms).autocomplete(
        source: (request, response) ->
          $.ajax(
            type: 'POST'
            url: "#{self.or.config.api_url}/api/entities/search"
            data: {
              type: 'magazines'
              terms: request.term
            }
            success: (data) ->
              console.log 'journals:', data
              results = for journal in data.records
                {
                  label: self.or.filters.l(journal._source.title)
                  value: journal._source.id
                  journal: journal._source
                }
              response(results)
          )
        focus: (event, ui) ->
          event.preventDefault()
        select: (event, ui) ->
          event.preventDefault()
          self.journals.push ui.item.journal
          $(event.target).val(null)
          self.notify()
      )

      $(self.root).on 'click', '.item', (event) ->
        event.preventDefault()
        id = parseInt($(event.currentTarget).attr('data-id'))
        item = null
        for i in self.journals
          item = i if i.id == id
        index = self.journals.indexOf(item)
        if index != -1
          self.journals.splice(index, 1)
          self.notify()

    self.notify = ->
      self.update()
      self.or.bus.trigger 'journals-filter', self.journals

  </script>

</or-journals-filter>