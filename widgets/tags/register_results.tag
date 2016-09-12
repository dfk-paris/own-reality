<or-register-results>

  <div>
    <div each={result in data.records} class="or-result">
      <or-attribute
        if={result._type == 'attribs'}
        attrib={result._source}
        onclick={attrib_click_handler(result)}
        shorten-to={300}
      ></or-attribute>
      <span if={result._type == 'people'}>
        <or-person
          person={result._source}
          machine={true}
        ></or-person>

        <span class="or-role" each={role_id in result._source.role_ids}>
          <a class="or-button" onclick={person_click_handler(parent.result, role_id)}>
            {parent.parent.or.i18n.t('search_as')}:
            {parent.parent.or.i18n.l(parent.parent.or.config.server.roles[role_id])}
          </a>
        </span>
      </span>
    </div>
  </div>

  <style type="text/scss">
    or-register-results {
      .or-result {
        margin-bottom: 0.5rem;
      }

      a {
        cursor: pointer;
      }

      .or-role {
        padding-right: 0.2rem;

        .or-button {
          font-size: 0.7rem;
          border-radius: 3px;
          padding: 0.2rem;
          background-color: darken(#ffffff, 20%);
          white-space: nowrap;
        }
      }
    }    
  </style>

  <script type="text/coffee">
    self = this

    self.opts.bus.on 'register-results', (data) ->
      # console.log data
      self.data = data
      self.update()

    self.person_click_handler = (item, role_id) ->
      (event) ->
        self.opts.bus.trigger 'person-clicked', role_id, item._id

    self.attrib_click_handler = (item) ->
      (event) ->
        self.opts.bus.trigger 'attrib-clicked', item._id

    self.urlFor = (item) -> "#"

  </script>

</or-register-results>