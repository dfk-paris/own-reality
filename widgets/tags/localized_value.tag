<or-localized-value>

  <span>{value()}</span>

  <script type="text/coffee">
    self = this
    
    self.value = -> self.or.i18n.l(opts.value)
  </script>
</or-localized-value>