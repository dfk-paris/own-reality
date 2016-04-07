<or-checkbox>
  <input
    type="checkbox"
    id={opts.id || otps.name}
    name={opts.name}
  />

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      $(self.root).on 'change', ->
        self.parent.trigger('or-change', self) if self.parent

    self.value = -> $(self.root).find('input').is(':checked')
  </script>
</or-checkbox>