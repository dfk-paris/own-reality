<or-medium>
  <div if={pdf_url()}>
    <a class="or-modal" href={pdf_url()}>
      <img if={url()} src={url()} />
      <span if={!url()}>PDF</span>
    </a>
    <div class="or-download" if={download_url()}>
      <a href={download_url()} download="article.pdf">
        {t('download')}
      </a>
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    
    tag.on 'mount', ->
      $(tag.root).on 'click', '.or-modal', (event) ->
        event.preventDefault()
        wApp.routing.packed modal: true, tag: 'or-iframe', src: tag.pdf_url()
        # wApp.bus.trigger 'modal', 'or-iframe', src: tag.pdf_url()

    tag.hash = ->
      tag.opts.item._source.file_base_hash ||
      if tag.opts.item._source.pdfs
        tag.lv(tag.opts.item._source.pdfs, notify: false)
      else
        null
    tag.has_preview = -> !!tag.opts.item._source.file_base_hash
    tag.url = -> 
      if tag.has_preview()
        "#{wApp.config.api_url}/files/#{tag.hash()}/140.jpg"
    tag.download_url = ->
      if tag.has_preview()
        filename = "#{tag.lv(tag.opts.item._source.title)}.pdf"
        "#{wApp.config.api_url}/api/entities/download/#{tag.hash()}.pdf?fn=#{filename}"
    tag.pdf_url = -> tag.opts.item._source.pdfs[tag.locale()]
  </script>
</or-medium>