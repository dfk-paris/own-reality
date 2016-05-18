<or-chronology-results>

  <div>
    <or-list-item
      each={item in or.data.records}
      item={item}
    />
  </div>

  <script type="text/coffee">
    self = this
    
    self.on 'mount', ->
      self.or.bus.on 'results', -> self.update()
  </script>

</or-chronology-results>