<or-pagination>

  <div show={pages() > 1}>
    <a href="#" show={page() != 1} class="previous">{or.i18n.t('previous_page')}</a>
    {page()}/{pages()}
    <a href="#" show={page() != pages()} class="next">{or.i18n.t('next_page')}</a>
  </div>

  <style type="text/scss">
    or-pagination {
      a {
        cursor: pointer;
      }
    }    
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      $(self.root).on 'click', 'a.previous', (event) ->
        event.preventDefault()
        self.or.routing.set_packed page: self.page() - 1
      $(self.root).on 'click', 'a.next', (event) ->
        event.preventDefault() 
        self.or.routing.set_packed page: self.page() + 1
      self.on 'results', -> self.update()

    self.per_page = -> self.opts.perPage || 10
    self.pages = -> Math.floor(self.opts.total / self.per_page()) + 1
    self.page = -> self.or.routing.unpack()['page'] || 1
  </script>

</or-pagination>