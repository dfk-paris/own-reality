<or-language-selector>

  <div>
    <select if={locales().length == 0}>
      <option
        each={l in or.i18n.locales}
        value={l}
        selected={l == or.i18n.locale()}
      >
        {or.i18n.t(l)}
      </option>
    </select>
    <span if={locales().length != 0}>
      {or.i18n.t('also_available_in')}:
      <a
        each={locale in locales()}
        class="button or-list-element"
        data-locale={locale}
      >
        <span>{locale}</span>
      </a>
    </span>
  </div>

  <style type="text/scss">
    or-language-selector {
      line-height: 1.5rem;

      a {
        cursor: pointer;
      }
      
      .or-list-element {
        padding-right: 0.2rem;

        & > span {
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
    

    self.on 'mount', ->
      
      $(self.root).find('select').on 'change', (event) ->
        value = $(event.target).val()
        self.or.routing.query(lang: value)

      $(self.root).on 'click', '.button', (event) ->
        event.preventDefault()
        value = $(event.target).parent().attr('data-locale')
        self.or.routing.query(lang: value)

    self.locales = ->
      (opts.locales || []).filter (e) -> e != self.or.i18n.locale()
  </script>

</or-language-selector>