<or-pagination>

  <div show={pages() > 1}>
    <a href="#" show={page() != 1} class="previous">{t('previous_page')}</a>
    {page()}/{pages()}
    <a href="#" show={page() != pages()} class="next">{t('next_page')}</a>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      $(tag.root).on 'click', 'a.previous', (event) ->
        event.preventDefault()
        wApp.routing.packed page: tag.page() - 1
      $(tag.root).on 'click', 'a.next', (event) ->
        event.preventDefault() 
        wApp.routing.packed page: tag.page() + 1
      tag.on 'results', -> tag.update()

    tag.per_page = -> tag.opts.perPage || 10
    tag.pages = -> Math.floor(tag.opts.total / tag.per_page()) + 1
    tag.page = -> wApp.routing.packed()['page'] || 1
  </script>

</or-pagination>