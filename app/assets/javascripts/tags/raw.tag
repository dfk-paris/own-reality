<raw>
  <span></span>

  <script type="text/coffee">
    self = this
    
    self.on 'update', ->
      self.root.innerHTML = self.opts.content
  </script>
</raw>