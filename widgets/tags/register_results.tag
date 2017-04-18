<or-register-results>

  <div if={data}>
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
            {t('search_as')}:
            {lv(wApp.config.server.roles[role_id])}
          </a>
        </span>
      </span>
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      tag.opts.bus.on 'register-results', onResults

    tag.on 'unmount', ->
      tag.opts.bus.off 'register-results', onResults

    onResults = (data) ->
      tag.data = data
      tag.update()

    tag.person_click_handler = (item, role_id) ->
      (event) ->
        tag.opts.bus.trigger 'person-clicked', role_id, item._id

    tag.attrib_click_handler = (item) ->
      (event) ->
        tag.opts.bus.trigger 'attrib-clicked', item._id

    tag.urlFor = (item) -> "#"

  </script>

</or-register-results>