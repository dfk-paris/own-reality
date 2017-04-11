<or-paper>
  
  <div class="raw"></div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'updated', ->
      if tag.opts.item
        if html = tag.opts.item._source.html
          Zepto(tag.root).find('.raw').html(tag.lv(html))
        else
          Zepto(tag.root).find('.raw').html "NO CONTENT AVAILABLE"
  </script>

</or-paper>