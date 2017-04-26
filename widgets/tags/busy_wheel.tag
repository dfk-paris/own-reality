<or-busy-wheel>
  
  <img src={url()}>

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      Zepto(document).ajaxSend ->
        Zepto(tag.root).css('display', 'inline-block')
      Zepto(document).ajaxStop ->
        Zepto(tag.root).css('display', 'none')

    tag.url = -> "#{wApp.api_url()}/spinner.gif"
  </script>

</or-busy-wheel>