<or-pagination>

  <div class="or" if={pages() > 1}>
    <span if={page() != 1}>
      <a href="#" show={page() != 2} onclick={first}>
        <or-icon which="left" />
        <or-icon which="left" />
        <span class="label">{t('first_page')}</span>
      </a>

      <a href="#" show={page() != 1} onclick={previous}>
        <or-icon which="left" />
        <span class="label">{t('previous_page')}</span>
      </a>
    </span>

    <span class="pages">
      <virtual  each={pr in pageRanges()}>
        <a
          show={pr != '...'}
          class="page {current: page() == pr}"
          onclick={goto(pr)}
        >{pr}</a>
        <span show={pr == '...'}>...</span>
      </virtual>
      <!-- <a
        each={n in pageList()}
        class="page {current: page() == n}"
        onclick={goto(n)}
      >{n}</a> -->
    </span>

    <span if={page() != pages()}>
      <a href="#" show={page() != pages()} onclick={next}>
        <span class="label">{t('next_page')}</span>
        <or-icon which="right" />
      </a>

      <a href="#" show={page() != pages() - 1} onclick={last}>
        <span class="label">{t('last_page')}</span>
        <or-icon which="right" />
        <or-icon which="right" />
      </a>
    </span>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)
    window.t = tag

    tag.on 'mount', ->
      tag.on 'results', -> tag.update()

    tag.first = (event) ->
      event.preventDefault()
      wApp.routing.packed page: null
    tag.next = (event) ->
      event.preventDefault() if event
      wApp.routing.packed page: tag.page() + 1
    tag.previous = (event) ->
      event.preventDefault() if event
      wApp.routing.packed page: tag.page() - 1
    tag.last = (event) ->
      event.preventDefault()
      wApp.routing.packed page: tag.pages()
    tag.goto = (newPage) ->
      (event) ->
        event.preventDefault()
        wApp.routing.packed page: newPage

    tag.per_page = -> tag.opts.perPage || 10
    tag.pages = -> Math.floor(tag.opts.total / tag.per_page()) + 1
    tag.pageList = ->
      base = [(tag.page() - 2)..(tag.page() + 2)]
      base.filter (e) -> e >= 1 && e <= tag.pages()
    tag.pageRanges = ->
      if tag.pages() < 7
        [1..tag.pages()]
      else
        r = switch tag.page()
          when 1 then [1, '...', tag.pages()]
          when 2 then [1, 2, '...', tag.pages()]
          when tag.pages() - 1 then [1, '...', tag.pages() - 1, tag.pages()]
          when tag.pages() then [1, '...', tag.pages()]
          else
            [1, '...', tag.page(), '...', tag.pages()]
        # console.log r
        r

    tag.page = -> wApp.routing.packed()['page'] || 1
  </script>

</or-pagination>