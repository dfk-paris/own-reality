<or-localized-value>

  <span>{value()}</span>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.value = -> self.or.filters.l(opts.value)
  </script>
</or-localized-value>