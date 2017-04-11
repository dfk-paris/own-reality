<or-content-localized-value>

  <span if={opts.value}>{value()}</span>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.value = ->
      tag.lv(tag.opts.value, content: true, notify: false)
  </script>
</or-content-localized-value>