<or-delayed-input>
  <input
    type={opts.type}
    placeholder={opts.placeholder}
  />

  <script type="text/coffee">
    self = this

    self.input = -> $(self.root).find('input')
    
    self.on 'mount', ->
      to = null
      $(self.root).on 'keyup', ->
        clearTimeout(to)
        to = setTimeout(self.notify, self.opts.timeout)

    self.value = -> self.input().val()
    self.reset = (notify = true) ->
      self.input().val(null)
      self.notify() if notify
    self.notify = ->
      self.to_packed_data()

    self.from_packed_data = (data) ->
      if data['terms'] != self.value()
        self.input().val data['terms']
        self.update()
    self.to_packed_data = ->
      self.or.routing.set_packed terms: self.value()

  </script>
</or-delayed-input>