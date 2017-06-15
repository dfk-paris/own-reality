<or-pdf-link if={hasPdf()}>

  <a href={pdfUrl()} onclick={onClick}>
    {t('download')}
  </a>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.onClick = (event) ->
      event.stopPropagation()

    # tag.pdfUrl = ->
    #   result = tag.opts.item._source.pdfs[tag.locale()]
    #   if tag.opts.download
    #     "#{wApp.api_url()}#{result}?fn=article.pdf"
    #   else
    #     "#{wApp.api_url()}#{result}"

    tag.hasPreview = -> !!tag.opts.item._source.file_base_hash
    tag.pdfUrl = ->
      if tag.hasPreview()
        filename = "#{tag.lv(tag.opts.item._source.title)}.pdf"
        hash = tag.opts.item._source.file_base_hash
        base = "#{wApp.api_url()}/api/entities/download"
        if tag.opts.download
          "#{base}/#{hash}.pdf?fn=#{filename}"
        else
          "#{wApp.api_url()}/files/#{hash}/original.pdf"
      else
        tag.opts.item._source.pdfs[tag.locale()]

    tag.hasPdf = ->
      pdfs = tag.opts.item._source.pdfs
      pdfs && pdfs[tag.locale()]
  </script>

</or-pdf-link>