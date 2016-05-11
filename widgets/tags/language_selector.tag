<or-language-selector>

  <div>
    <select if={locales().length == 0}>
      <option
        each={l in or.locales}
        value={l}
        selected={l == or.locale()}
      >
        {or.filters.t(l)}
      </option>
    </select>
    <span if={locales().length != 0}>
      {window.or.filters.t('also_available_in')}: 
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
    self.or = window.or

    self.on 'mount', ->
      
      $(self.root).find('select').on 'change', (event) ->
        value = $(event.target).val()
        self.or.route.query(lang: value)

      $(self.root).on 'click', '.button', (event) ->
        event.preventDefault()
        value = $(event.target).parent().attr('data-locale')
        self.or.route.query(lang: value)

    self.locales = ->
      (opts.locales || []).filter (e) -> e != self.or.locale()
  </script>

</or-language-selector>