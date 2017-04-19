<or-chronology-results>

  <or-list-item
    each={item in wApp.cache.data.records}
    item={item}
  />

  <script type="text/coffee">
    tag = this
    
    tag.on 'mount', ->
      wApp.bus.on 'results', -> tag.update()
  </script>

</or-chronology-results>