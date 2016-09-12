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
        overflow-y: auto;

        iframe {
          border: none;
          height: 495px;
          width: 100%;
        }

        .or-custom-tag {
          padding: 1rem;
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
        #   console.log self.or.routing.unpack()
          self.or.routing.set_packed modal: null, tag: null, id: null, clang: null
      )

      $(window).on 'resize', fix_height

    self.or.bus.on 'modal', (url_or_tag, opts) ->
      # console.log 'building modal with', arguments
      if opts
        self.src = null
        riot.mount $(self.root).find('.or-custom-tag')[0], url_or_tag, opts
      else
        self.src = url_or_tag
      
      self.update()
      fix_height()
      self.modal.trigger 'openModal'

    self.or.bus.on 'close-modal', ->  self.modal.trigger 'closeModal'
    self.or.bus.on 'reset-search-with', -> self.modal.trigger('closeModal')

    fix_height = ->
      new_height = Math.max($(window).height() - 100, 500)
      $(self.root).find('.or-modal').css 'height', new_height

  </script>
</or-modal>
