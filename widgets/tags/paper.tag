<or-paper>
  
  <div class="body"></div>
  <div class="panel"></div>
  <div class="w-clearfix"></div>
  <or-icon which="up" />

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    window.t = tag

    tag.on 'mount', ->
      Zepto(tag.root).on 'click', "a[href*='/resolve/']", (event) ->
        event.preventDefault()
        console.log 'clicked!', event
        href = Zepto(event.currentTarget).attr('href')
        [x, type, id, lang] = href.match(/\/resolve\/(\w+)\/(\d+)\/(\w+)$/)
        t = type.slice(0, type.length - 1)
        wApp.routing.packed(tag: "or-#{t}", type: type, id: id, lang: lang)

      Zepto(tag.root).on 'click', "a.suite, a.tonote, a.noteNum, a.tosub", (event) ->
        event.preventDefault()
        anchor = Zepto(event.currentTarget).attr('href').replace('#', '')
        wApp.utils.scrollTo Zepto("[name=#{anchor}], anchor[id=#{anchor}]"), Zepto('.receiver')

    tag.on 'updated', ->
      if tag.opts.item
        if html = tag.html()
          # insert html
          Zepto(tag.root).find('.body').html(html)
        else
          Zepto(tag.root).find('.body').html "NO CONTENT AVAILABLE"

    tag.html = ->
      original = tag.lv(tag.opts.item._source.html)
      doc = Zepto(original)

      # add index
      content = Zepto('<div class="index">')
      content.append('<p>' + tag.t('content') + '</p>')
      tpl = Zepto('<a class="tosub" href="#">')
      for h2 in doc.find('h2')
        h2 = Zepto(h2)
        anchor = h2.find('anchor').attr('id')
        h2.find('a.totdm, a.tonote, .manchette').remove()
        l = tpl.clone()
        l.html(h2.text())
        l.attr 'href', "##{anchor}"
        content.append(l)
      doc.find('.docAuthor').after(content)

      # add footnote header
      doc.find('.notes').prepend("<hr /><h2>Notes</h2>")

      doc

  </script>

</or-paper>