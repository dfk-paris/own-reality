<or-language-selector>

  <div>
    <select
      onchange={newSelection}
      ref="combo"
    >
      <option
        each={l in locales()}
        value={l}
        selected={l == locale()}
      >
        {t(l)}
      </option>
    </select>
    <!-- <span if={locales().length != 0}>
      {t('also_available_in')}:
      <a
        each={locale in locales()}
        class="button or-list-element"
        data-locale={locale}
      >
        <span>{locale}</span>
      </a>
    </span> -->
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      # Zepto(tag.root).on 'click', '.button', (event) ->
      #   event.preventDefault()
      #   value = Zepto(event.target).parent().attr('data-locale')
      #   wApp.routing.packed clang: value

      wApp.bus.on 'routing:query', tag.from_packed_data

    tag.on 'unmount', ->
      wApp.bus.off 'routing:query', tag.from_packed_data

    tag.newSelection = (event) ->
      value = Zepto(tag.refs.combo).val()
      wApp.routing.packed lang: value

    tag.locales = ->
      wApp.i18n.locales
      # (opts.locales || []).filter (e) -> e != wApp.i18n.locale(true)

    tag.from_packed_data = ->
      value = Zepto(tag.root).find('select').val()


  </script>

</or-language-selector>