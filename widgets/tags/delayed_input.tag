<or-delayed-input>
  <!-- <input
    type={opts.type}
    placeholder={opts.placeholder}
    onkeyup={console.log}
  /> -->
  <input
    type={opts.type}
    placeholder={opts.placeholder}
  />

  <script type="text/coffee">
    tag = this

    tag.input = -> $(tag.root).find('input')
    
    tag.on 'mount', ->
      to = null
      Zepto(tag.root).on 'keyup', ->
        clearTimeout(to)
        to = setTimeout(tag.notify, tag.opts.timeout)
      wApp.bus.on 'routing:query', tag.from_packed_data

    tag.on 'unmount', ->
      wApp.bus.off 'routing:query', tag.from_packed_data

    tag.onKeyUp = (event) ->
      clearTimeout(to)
      to = setTimeout(tag.notify, tag.opts.timeout)
    tag.value = -> tag.input().val()
    tag.reset = (notify = true) ->
      tag.input().val(null)
      tag.notify() if notify
    tag.notify = ->
      tag.to_packed_data()


    tag.from_packed_data = ->
      terms = wApp.routing.packed()['terms']
      if terms != tag.value()
        tag.input().val terms
        tag.update()
    tag.to_packed_data = ->
      wApp.routing.packed terms: tag.value(), page: 1

  </script>
</or-delayed-input>