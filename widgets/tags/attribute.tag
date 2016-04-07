<or-attribute>

  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.attr = -> self.or.cache.attr_lookup[self.opts.key]
    self.label = -> self.or.filters.l(self.attr().name)
  </script>

</or-attribute>