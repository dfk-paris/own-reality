<or-attribute>

  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.attr = -> self.or.cache.attr_lookup[self.opts.key]
    self.label = ->
      result = self.or.filters.l(self.attr().name)
      if result.length > 30
        result.substr(0, 30 - 1) + '…'
      else
        result
  </script>

</or-attribute>