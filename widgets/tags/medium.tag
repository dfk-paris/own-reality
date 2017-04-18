<or-medium>

  <div if={hasPdf()}>

    <a class="or-modal" href={pdfUrl()}>
      <img if={hasPreview()} src={previewUrl()} />

      <span if={!hasPreview()}>PDF</span>
    </a>

    <div class="or-download" if={hasPdf()}>
      <a href={pdfUrl()} download="article.pdf">
        {t('download')}
      </a>
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      Zepto(tag.root).on 'click', '.or-modal', (event) ->
        event.preventDefault()
        url = Zepto(event.currentTarget).attr('href')
        wApp.routing.packed modal: true, tag: 'or-iframe', src: url

    tag.hasPreview = -> !!tag.opts.item._source.file_base_hash
    tag.previewUrl = -> 
      hash = tag.opts.item._source.file_base_hash
      "#{wApp.config.api_url}/files/#{hash}/140.jpg"
    tag.hasPdf = ->
      pdfs = tag.opts.item._source.pdfs
      tag.hasPreview() || (pdfs && pdfs[tag.locale()])
    tag.pdfUrl = (download = false) ->
      if tag.hasPreview()
        filename = "#{tag.lv(tag.opts.item._source.title)}.pdf"
        hash = tag.opts.item._source.file_base_hash
        base = "#{wApp.config.api_url}/api/entities/download"
        if download
          "#{base}/#{hash}.pdf?fn=#{filename}"
        else
          "#{wApp.config.api_url}/files/#{hash}/original.pdf"
      else
        tag.opts.item._source.pdfs[tag.locale()]

  </script>
</or-medium>