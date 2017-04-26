<or-doc>
  
  <div class="body" name="or-article"></div>
  <!-- <div class="panel"></div> -->
  <div class="w-clearfix"></div>
  <or-icon which="up" />

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      Zepto(tag.root).on 'click', "a[href*='/resolve/']", (event) ->
        event.preventDefault()
        href = Zepto(event.currentTarget).attr('href')
        [x, type, id, lang] = href.match(/\/resolve\/(\w+)\/(\d+)\/(\w+)$/)
        t = type.slice(0, type.length - 1)
        wApp.routing.packed(tag: "or-paper", id: id, lang: lang)

    tag.on 'updated', ->
      if tag.opts.item
        if html = tag.html()
          # insert html
          Zepto(tag.root).find('.body').html(html)
          tag.fixManchettePositions()
        else
          Zepto(tag.root).find('.body').html "NO CONTENT AVAILABLE"

    tag.html = ->
      original = tag.lcv(tag.opts.item._source.html)
      doc = Zepto(original)
      tag.addIndex(doc)
      tag.addFootNoteHeader(doc)
      tag.fixImgSrc(doc)
      doc

    tag.addIndex = (doc) ->
      content = Zepto('<div class="index">')
      content.append('<p>' + tag.tcap('content') + '</p>')
      tpl = Zepto('<a class="tosub" href="#">')
      if doc.find('h2').length > 0
        for h2 in doc.find('h2')
          h2 = Zepto(h2)
          anchor = h2.find('anchor').attr('id')
          h2.find('a.totdm, a.tonote, .manchette').remove()
          l = tpl.clone()
          l.html(h2.text())
          l.attr 'href', "##{anchor}"
          content.append(l)
        doc.find('.docAuthor').after(content)

    tag.addFootNoteHeader = (doc) ->
      doc.find('.notes').prepend("<hr /><h2>Notes</h2>")

    tag.fixImgSrc = (doc) ->
      for img in doc.find('img')
        img = Zepto(img)
        img.attr 'src', "#{wApp.api_url()}/#{img.attr('src')}"

    tag.fixManchettePositions = ->
      previousNote = null
      for manchette in Zepto(".manchette")
        manchette = Zepto(manchette)
        if previousNote != null
          minTop = previousNote.position().top + previousNote.height() + 15
          if manchette.position().top < minTop
            manchette.css "top", "#{minTop}px"
        previousNote = manchette

  </script>

</or-doc>