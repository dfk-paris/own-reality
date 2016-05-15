<or-medium>
  <div if={pdf_url()}>
    <a class="or-modal" href={pdf_url()}>
      <img if={url()} src={url()} />
      <span if={!url()}>PDF</span>
    </a>
    <div class="or-download" if={download_url()}>
      <a href={download_url()}>
        {or.i18n.t('download')}
      </a>
    </div>
  </div>

  <style type="text/scss">
    or-medium {
      text-align: right;

      img {
        width: 140px !important;
        border-radius: 6px;
      }

      .or-download {
        margin-top: 1rem;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    

    self.on 'mount', ->
      $(self.root).on 'click', '.or-modal', (event) ->
        event.preventDefault()
        self.or.bus.trigger 'modal', self.pdf_url()

    self.hash = ->
      self.opts.item._source.file_base_hash ||
      self.or.i18n.l(self.opts.item._source.pdfs, false)
    self.has_preview = -> !!self.opts.item._source.file_base_hash
    self.url = -> 
      if self.has_preview()
        "#{self.or.config.api_url}/files/#{self.hash()}/140.jpg"
    self.download_url = ->
      if self.has_preview()
        "#{self.or.config.api_url}/api/entities/download/#{self.hash()}.pdf"
    self.pdf_url = ->
      if self.hash()
        "#{self.or.config.api_url}/files/#{self.hash()}/original.pdf"
  </script>
</or-medium>