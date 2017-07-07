<or-attribute-selector>

  <or-icon which="close" onclick={onClickClose} />

  <div class="or-frame">
    <or-register
      or-type={opts.orType}
      or-category-id={opts.orCategoryId}
      bus={opts.bus}
    />

    <or-register-results bus={opts.bus} />
  </div>

  <script type="text/coffee">
    tag = this

    tag.onClickClose = ->
      wApp.bus.trigger 'close-modal'
  </script>

</or-attribute-selector>