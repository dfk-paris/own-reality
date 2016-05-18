<or-checkbox>
  <input
    type="checkbox"
    id="{opts.id || otps.name}"
    name={opts.name}
  />

  <script type="text/coffee">
    self = this
    

    self.on 'mount', ->
      $(self.root).on 'change', self.notify

    self.value = -> $(self.root).find('input').is(':checked')
    self.reset = (notify = true) ->
      $(self.root).attr 'checked', null
      self.notify() if notify

    self.notify = -> self.parent.trigger('or-change', self) if self.parent
  </script>
</or-checkbox>