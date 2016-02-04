<or-papers>

  <div class="or-papers">
    <div class="list" if={items}>
      <h1>{opts.label || 'Papers'}</h1>

      <ul>
        <li each={items}>
          <a if={_source.html} href="#/papers/{parent.type}/{_id}">
            {parent.localize(_source.title)}
          </a>
          <span if={!_source.html}>
            {parent.localize(_source.title)}
          </span>
        </li>
      </ul>
    </div>

    <div class="item" if={!items}>
      <raw content={localize(item._source.html)}></raw>
    </div>
  </div>

  <style type="text/scss">
    .or-papers .item {
      ul#ariane {display: none;}
      h2.publiParente {display: none;}

      div#texte {
        p {
          text-align: justify;

          span.paranumber {
            display: block;
            float: left;
            margin-left: -2em;
            color: #aea79f;
          }

          a.footnotecall {
            vertical-align: super;
            font-size: 0.7em;
          }

          img {
            max-width: 100%;
          }
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.mixin(window.or)

    self.handle_routing = (x, type, id, footnote) ->
      self.items = null
      self.type = type
      self.id = id
      self.footnote = footnote

      if self.id
        jQuery.ajax(
          url: "#{self.config.base_url}/api/papers/#{self.opts.type}/#{self.id}"
          dataType: 'json'
          success: (data) ->
            console.log data
            self.item = data
            self.update()
        )
      else
        jQuery.ajax(
          url: "#{self.config.base_url}/api/papers/#{self.opts.type}"
          dataType: 'json'
          success: (data) ->
            console.log data
            self.items = data
            self.update()
        )

    self.tags.raw.on 'updated', ->
      if self.footnote
        self.scroll_to "#ftn#{self.footnote}"
      else
        self.scroll_to 'body'

    self.paper_path = -> "/papers/#{self.type}/#{self.id}"

    self.on 'mount', ->
      $(self.root).on 'click', 'a.footnotecall', (event) ->
        event.preventDefault()
        id = $(event.currentTarget).attr('id').match(/\d+$/)[0]
        url = "#{self.paper_path()}/#{id}"
        self.routing(url)
      $(self.root).on 'click', 'a.FootnoteSymbol', (event) ->
        event.preventDefault()

      self.routing = riot.route.create()
      self.routing(self.handle_routing)

      riot.route.base '#/'
      unless document.location.hash
        riot.route "/papers/#{self.opts.type}"
      riot.route.start(true)

  </script>

</or-papers>