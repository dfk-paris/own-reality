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

    self.el = -> $(self.root).find('.or-slider')
    
    self.min = -> parseInt(self.opts.min)
    self.max = -> parseInt(self.opts.max)

    self.on 'mount', ->
      self.el().slider(
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

      self.or.bus.on 'packed-data', self.from_packed_data

    self.value = -> [self.lower, self.upper]
    self.reset = (notify = true) ->
      self.el().slider 'values', [self.min(), self.max()]
      self.notify() if notify
    self.notify = -> self.to_packed_data()

    self.from_packed_data = (data) ->
      if data['lower'] != self.lower || data['upper'] != self.upper
        self.el().slider 'values', [data['lower'], data['upper']]
        self.lower = data['lower']
        self.upper = data['upper']
        self.update()
    self.to_packed_data = ->
      self.or.routing.set_packed(
        page: 1
        lower: self.value()[0]
        upper: self.value()[1]
      )

  </script>

</or-slider>