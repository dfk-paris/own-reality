<or-attribute>

  <span title={full()}>{short()}</span>

  <script type="text/coffee">
    self = this
    
    self.attr = -> self.or.cache.attrs[self.opts.key]
    self.full = -> self.or.i18n.l(self.attr().name)
    self.short = ->
      result = self.full()
      if result.length > 30
        result.substr(0, 30 - 1) + '…'
      else
        result
  </script>

</or-attribute>