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

  <style type="text/scss">
    or-slider 
      .or-min {
        float: left;
      }

      .or-max {
        float: right;
      }

      .or-current {
        text-align: center;
      }

      .or-clearfix {
        clear: both;
      }
  </style>

  <script type="text/coffee">
    self = this
    
    self.min = -> parseInt(self.opts.min)
    self.max = -> parseInt(self.opts.max)

    self.on 'mount', ->
      $(self.root).find('.or-slider').slider(
        range: true
        min: self.min()
        max: self.max()
        values: [self.min(), self.max()]
        slide: (event, ui) ->
          self.lower = ui.values[0]
          self.upper = ui.values[1]
          self.update()
        stop: (event, ui) -> self.notify()
      )

    self.value = -> [self.lower, self.upper]
    self.reset = (notify = true) ->
      $(self.root).find('.or-slider').slider 'values', [self.min(), self.max()]
      self.notify() if notify
    self.notify = -> self.parent.trigger('or-change', self) if self.parent

  </script>

</or-slider>