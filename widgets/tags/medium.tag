<or-medium>

  <div if={hasPdf()}>

    <img if={hasPreview()} src={previewUrl()} />
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      Zepto(tag.root).on 'click', '.or-modal', onModalClick
      Zepto(tag.root).on 'click', 'a', onClick

    tag.on 'unmount', ->
      Zepto(tag.root).off 'click', '.or-modal', onModalClick
      Zepto(tag.root).off 'click', 'a', onClick

    onModalClick = (event) ->
      event.preventDefault()
      url = Zepto(event.currentTarget).attr('href')
      wApp.routing.packed modal: true, tag: 'or-iframe', src: url

    onClick = (event) -> event.stopPropagation()

    tag.hasPreview = -> !!tag.opts.item._source.file_base_hash
    tag.previewUrl = -> 
      hash = tag.opts.item._source.file_base_hash
      "#{wApp.api_url()}/files/#{hash}/140.jpg"
    tag.hasPdf = ->
      pdfs = tag.opts.item._source.pdfs
      tag.hasPreview() || (pdfs && pdfs[tag.locale()])
    tag.pdfUrl = (download = false) ->
      if tag.hasPreview()
        filename = "#{tag.lv(tag.opts.item._source.title)}.pdf"
        hash = tag.opts.item._source.file_base_hash
        base = "#{wApp.api_url()}/api/entities/download"
        if download
          "#{base}/#{hash}.pdf?fn=#{filename}"
        else
          "#{wApp.api_url()}/files/#{hash}/original.pdf"
      else
        tag.opts.item._source.pdfs[tag.locale()]

  </script>
</or-medium>