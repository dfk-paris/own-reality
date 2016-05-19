<or-attribute key={attr().id} title={desc()}>

  <span>{short()}</span>

  <style type="text/scss">
    or-attribute {
      cursor: pointer;
    }
  </style>

  <script type="text/coffee">
    self = this

    self.attr = -> 
      self.opts.attrib || self.or.cache.attrs[self.opts.key]
    self.full = -> self.or.i18n.l(self.attr().name)
    self.short = ->
      result = self.full()
      if result.length > 30
        result.substr(0, 30 - 1) + '…'
      else
        result
    self.desc = ->
      "#{self.attr().id}: #{self.full()}"
  </script>

</or-attribute>