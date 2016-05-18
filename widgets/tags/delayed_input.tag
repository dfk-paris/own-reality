<or-delayed-input>
  <input
    type={opts.type}
    placeholder={opts.placeholder}
  />

  <script type="text/coffee">
    self = this
    
    self.on 'mount', ->
      to = null
      $(self.root).on 'keyup', ->
        clearTimeout(to)
        to = setTimeout(self.notify, self.opts.timeout)

    self.value = -> $(self.root).find('input').val()
    self.reset = (notify = true) ->
      $(self.root).find('input').val(null)
      self.notify() if notify
    self.notify = -> self.parent.trigger('or-change', self) if self.parent
  </script>
</or-delayed-input>