<or-localized-value>

  <span>{value()}</span>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.value = -> tag.lv(opts.riotValue)
  </script>
</or-localized-value>