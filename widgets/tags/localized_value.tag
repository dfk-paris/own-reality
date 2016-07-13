<or-localized-value>

  <span>{value()}</span>

  <style type="text/scss">
    or-localized-value {
      display: inline;
    }
  </style>

  <script type="text/coffee">
    self = this
    
    self.value = -> self.or.i18n.l(opts.value)
  </script>
</or-localized-value>