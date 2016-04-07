<or-language-selector>

  <select>
    <option each={l in or.locales} value={l} selected={l == or.locale()}>
      {or.filters.t(l)}
    </option>
  </select>
  
  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      $(self.root).on 'change', (event) ->
        value = $(event.target).val()
        self.or.route.query(lang: value)
  </script>

</or-language-selector>