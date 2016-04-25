<or-chronology-results>

  <div>
    <or-list-item
      each={item in self.or.data.records}
      item={item}
    />
  </div>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      self.or.bus.on 'results', -> self.update()
  </script>

</or-chronology-results>