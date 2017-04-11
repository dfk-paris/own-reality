<or-modal>
  <div class="or-modal" style="display: none">
    <iframe show={src} src={src}></iframe>
    <div hide={src} class="or-custom-tag"></div>
  </div>

  <script type="text/coffee">
    tag = this
    
    tag.src = null

    tag.on 'mount', ->
      tag.modal = $(tag.root).find('.or-modal').easyModal(
        top: 50
        autoOpen: false
        hasVariableWidth: true
        onClose: ->
        #   console.log tag.or.routing.unpack()
          tag.or.routing.set_packed modal: null, tag: null, id: null, clang: null
      )

      $(window).on 'resize', fix_height

    tag.or.bus.on 'modal', (url_or_tag, opts) ->
      # console.log 'building modal with', arguments
      if opts
        tag.src = null
        riot.mount $(tag.root).find('.or-custom-tag')[0], url_or_tag, opts
      else
        tag.src = url_or_tag
      
      tag.update()
      fix_height()
      tag.modal.trigger 'openModal'

    wApp.bus.on 'close-modal', ->  tag.modal.trigger 'closeModal'
    wApp.bus.on 'reset-search-with', -> tag.modal.trigger('closeModal')

    fix_height = ->
      new_height = Math.max($(window).height() - 100, 500)
      $(tag.root).find('.or-modal').css 'height', new_height

  </script>
</or-modal>
