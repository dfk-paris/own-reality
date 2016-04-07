<or-chronology-detail>
  
  <div class="chronology-detail">
    <or-item-value label="title" value={localize(item._source.title)} />
  </div>

  <script type="text/coffee">
    self = this
    self.mixin(window.or)

    self.bus.on 'chrono-select', (item) ->
      console.log item
      self.item = item
      self.update()
  </script>

</or-chronology-detail>