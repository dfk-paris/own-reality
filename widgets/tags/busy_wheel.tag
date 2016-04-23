<or-busy-wheel>
  
  <img src={url()}>

  <style type="text/scss">
    or-busy-wheel {
      width: 64px;
      height: 64px;
      display: none;

      img {
        width: 100%;
        height: 100%;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      $(document).ajaxSend ->
        $(self.root).css('display', 'inline-block')
      $(document).ajaxStop ->
        $(self.root).css('display', 'none')

    self.url = -> "#{self.or.config.api_url}/spinner.gif"
  </script>

</or-busy-wheel>