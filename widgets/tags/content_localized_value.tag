<or-content-localized-value>

  <span>{value()}</span>

  <script type="text/coffee">
    self = this
    
    self.value = -> self.or.i18n.l(opts.value, content: true)
  </script>
</or-content-localized-value>