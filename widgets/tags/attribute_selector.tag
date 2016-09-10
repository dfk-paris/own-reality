<or-attribute-selector>

  <or-register
    or-type={opts.orType}
    or-category={opts.orCategory}
    bus={opts.bus}
  />
  <or-register-results bus={opts.bus} />
  <div class="clearfix"></div>

  <style type="text/scss">
    or-attribute-selector, [data-is=or-attribute-selector] {
      or-register {
        display: block;
        float: left;
        width: 33.33%;
      }
      or-register-selector {
        display: block;
        float: left;
        width: 66.66%;
      }
    }
  </style>

  <script type="text/coffee">
    tag = this
  </script>

</or-attribute-selector>