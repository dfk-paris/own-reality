<or-attribute>

  <span title={full()}>{short()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.attr = -> self.or.cache.attr_lookup[self.opts.key]
    self.full = -> self.or.filters.l(self.attr().name)
    self.short = ->
      result = self.full()
      if result.length > 30
        result.substr(0, 30 - 1) + '…'
      else
        result
  </script>

</or-attribute>