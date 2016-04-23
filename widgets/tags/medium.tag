<or-medium>
  <div if={hash()}>
    <a class="or-modal" href={pdf_url()}>
      <img src={url()} />
    </a>
    <div class="or-download">
      <a href={download_url()}>
        {or.filters.t('download')}
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
    self.or = window.or

    self.on 'mount', ->
      $(self.root).on 'click', '.or-modal', (event) ->
        event.preventDefault()
        self.or.bus.trigger 'modal', self.pdf_url()

    self.hash = -> self.opts.item._source.file_base_hash
    self.url = -> 
      if self hash()
        "#{self.or.config.api_url}/files/#{self.hash()}/140.jpg"
    self.download_url = ->
      "#{self.or.config.api_url}/api/entities/download/#{self.hash()}.pdf"
    self.pdf_url = ->
      "#{self.or.config.api_url}/files/#{self.hash()}/original.pdf"
  </script>
</or-medium>