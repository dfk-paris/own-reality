<or-slider>
  
  <div>
    <div class="or-slider"></div>
    <div class="or-min">{opts.min}</div>
    <div class="or-max">{opts.max}</div>
    <div
      if={lower && upper}
      class="or-current"
    >{lower} – {upper}</div>
    <div class="or-clearfix"></div>
  </div>

  <script type="text/coffee">
    tag = this

    tag.el = -> Zepto(tag.root).find('.or-slider')
    
    tag.min = -> parseInt(tag.opts.min)
    tag.max = -> parseInt(tag.opts.max)

    tag.on 'mount', ->
      tag.el().slider(
        range: true
        min: tag.min()
        max: tag.max()
        values: [tag.min(), tag.max()]
        slide: (event, ui) ->
          tag.lower = ui.values[0]
          tag.upper = ui.values[1]
          tag.update()
        stop: (event, ui) -> tag.notify()
      )

      wApp.bus.on 'routing:query', tag.from_packed_data

    tag.on 'unmount', ->
      wApp.bus.off 'routing:query', tag.from_packed_data

    tag.value = -> [tag.lower, tag.upper]
    tag.reset = (notify = true) ->
      tag.el().slider 'values', [tag.min(), tag.max()]
      tag.notify() if notify
    tag.notify = -> tag.to_packed_data()

    tag.from_packed_data = ->
      data = wApp.routing.packed()
      if data['lower'] != tag.lower || data['upper'] != tag.upper
        tag.el().slider 'values', [data['lower'], data['upper']]
        tag.lower = data['lower']
        tag.upper = data['upper']
        tag.update()
    tag.to_packed_data = ->
      wApp.routing.packed(
        page: 1
        lower: tag.value()[0]
        upper: tag.value()[1]
      )

  </script>

</or-slider>