<or-attribute key={attr().id} title={desc()}>

  <span>{short()}</span>

  <style type="text/scss">
    or-attribute {
      cursor: pointer;
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      unless self.attr()
        self.or.cache_attributes([self.opts.key])

    self.attr = ->
      self.opts.attrib || self.or.cache.attrs[self.opts.key]
    self.full = -> self.or.i18n.l(self.attr().name)
    self.short = ->
      amount = self.opts.shortenTo || 30
      result = self.full()
      if result.length > amount
        result.substr(0, amount - 1) + '…'
      else
        result
    self.desc = ->
      "#{self.attr().id}: #{self.full()}"
  </script>

</or-attribute>