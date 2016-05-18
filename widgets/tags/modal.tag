<or-modal>
  <div class="or-modal" style="display: none">
    <iframe show={src} src={src}></iframe>
    <div hide={src} class="or-custom-tag"></div>
  </div>

  <style type="text/scss">
    or-modal {
      .or-modal {
        background-color: #ffffff;
        position: absolute;
        width: 60%;
        height: 500px;

        iframe {
          border: none;
          height: 500px;
          width: 100%;
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    
    self.src = null

    self.on 'mount', ->
      self.modal = $(self.root).find('.or-modal').easyModal(
        top: 50
        autoOpen: false
        hasVariableWidth: true
        onClose: ->
          self.or.routing.query modal: null, tag: null, id: null, clang: null
      )

    self.or.bus.on 'modal', (url_or_tag, opts) ->
      # console.log arguments
      if opts
        self.src = null
        riot.mount $(self.root).find('.or-custom-tag')[0], url_or_tag, opts
      else
        self.src = url_or_tag
      
      self.update()
      self.modal.trigger 'openModal'

    self.or.bus.on 'reset-search-with', -> self.modal.trigger('closeModal')

  </script>
</or-modal>
