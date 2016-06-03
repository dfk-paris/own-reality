<or-chronology-detail>
  
  <div class="chronology-detail">
    <or-item-metadata item={opts.item} />
  </div>
    
  <script type="text/coffee">
    self = this
    
    self.on 'mount', ->
      self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])

    self.t = self.or.i18n.t
  </script>

</or-chronology-detail>