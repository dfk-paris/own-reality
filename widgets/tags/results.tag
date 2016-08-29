<or-results>
  
  <div class="result-tabs">
    <div class="controls">
      <a name="sources" class={current: (current_tab == 'sources')}>
        {or.i18n.t('source', {count: 'other', capitalize: true})}
        ({or.data.aggregations['sources'].doc_count})
      </a>
      <a name="magazines" class={current: (current_tab == 'magazines')}>
        {or.i18n.t('magazine', {count: 'other', capitalize: true})}
        ({or.data.aggregations['magazines'].doc_count})
      </a>
      <a name="interviews" class={current: (current_tab == 'interviews')}>
        {or.i18n.t('interview', {count: 'other', capitalize: true})}
        ({or.data.aggregations['interviews'].doc_count})
      </a>
      <a name="articles" class={current: (current_tab == 'articles')}>
        {or.i18n.t('article', {count: 'other', capitalize: true})}
        ({or.data.aggregations['articles'].doc_count})
      </a>
      <div class="clearfix"></div>
    </div>

    <or-item-list
      items={or.data.results}
      total={or.data.total}
      per-page={per_page()}
    />
  </div>

  <style type="text/scss">
    or-results {
      .controls {
        margin-bottom: 1.5rem;


        a {
          display: block;
          float: left;
          width: 25%;
          box-sizing: border-box;
          cursor: pointer;
          padding: 0.5rem;
          padding-top: 0.8rem;
          padding-bottom: 0.8rem;
          background-color: #efefef;
          border-radius: 3px;
          font-family: sans-serif;
          text-decoration: none;
          font-size: 0.8rem;

          &.current {
            background-color: #ffffff;
            border-top: 0.2rem solid #6e6e6e;
            padding-top: 0.6rem;
          }
        }
      }


      ul li:before {
        content: none !important;
      }

      .tab {
        ul > li {
          padding-bottom: 0px;

          & > img.icon {
            width: 1rem;
          }
        }
      }

      .clearfix {
        clear: both;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    
    self.current_tab = 'sources'

    self.on 'mount', ->
      $(self.root).find('.tab').hide()
      $(self.root).find('.tab.sources').show()

      $(self.root).on 'click', '.controls a', (event) ->
        event.preventDefault()
        name = $(event.target).attr('name')
        self.or.routing.set_packed type: name, page: 1

      self.or.bus.on 'results', ->
        # console.log 'results', self.or.data
        self.update()

      self.or.bus.on 'type-aggregations', -> self.update()

      self.or.bus.on 'packed-data', self.from_packed_data

    self.from_packed_data = (data) ->
      if data['type'] != self.current_tab
        self.current_tab = data['type'] || 'sources'
        self.update()

    self.per_page = -> if self.current_tab == 'sources' then 10 else 100

  </script>
  
</or-results>