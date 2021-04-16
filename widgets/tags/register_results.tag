<or-register-results>

  <div if={data}>
    <div class="or-search-header">Index {index}</div>

    <div class="or-badge-list">
      <span each={result in data.records} class="or-result or-item-wrapper">
        <span class="or-item">
          +
          <or-attribute
            if={wApp.utils.isType(result, 'attribs')}
            attrib={result._source}
            onclick={attrib_click_handler(result)}
            shorten-to={300}
          ></or-attribute>
          <span if={wApp.utils.isType(result, 'people')}>
            <or-person
              person={result._source}
              machine={true}
            ></or-person>

            <span class="or-role" each={role_id in result._source.role_ids}>
              <a class="or-button" onclick={person_click_handler(parent.result, role_id)}>
                ({lv(wApp.config.server.roles[role_id])})
              </a>
            </span>
          </span>
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

    onResults = (data, index) ->
      tag.index = index.toUpperCase()
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