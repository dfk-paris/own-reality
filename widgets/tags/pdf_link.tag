<or-pdf-link>

  <a if={hasPdf()} href={pdfUrl()} onclick={onClick}>
    {t('download')}
  </a>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.onClick = (event) ->
      event.stopPropagation()

    tag.pdfUrl = ->
      result = tag.opts.item._source.pdfs[tag.locale()]
      if tag.opts.download
        "#{wApp.api_url()}/#{result}?fn=article.pdf"
      else
        "#{wApp.api_url()}/#{result}"

    tag.hasPdf = ->
      pdfs = tag.opts.item._source.pdfs
      pdfs && pdfs[tag.locale()]
  </script>

</or-pdf-link>