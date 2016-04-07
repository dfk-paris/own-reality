<or-delayed-input>
  <input
    type={opts.type}
    placeholder={opts.placeholder}
  />

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      to = null
      $(self.root).on 'keyup', ->
        clearTimeout(to)
        to = setTimeout(self.set, self.opts.timeout)

    self.set = -> self.parent.trigger('or-change', self) if self.parent
    self.value = -> $(self.root).find('input').val()
  </script>
</or-delayed-input>