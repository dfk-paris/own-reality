<or-results>
  
  <div class="result-tabs">
    <div class="controls">
      <a name="articles">
        {or.filters.t('article', {count: 'other'})}
        ({or.data.aggregations['articles'].doc_count})
      </a>
      <a name="magazines">
        {or.filters.t('magazine', {count: 'other'})}
        ({or.data.aggregations['magazines'].doc_count})
      </a>
      <a name="interviews">
        {or.filters.t('interview', {count: 'other'})}
        ({or.data.aggregations['interviews'].doc_count})
      </a>
      <a name="sources">
        {or.filters.t('source', {count: 'other'})}
        ({or.data.aggregations['sources'].doc_count})
      </a>
    </div>
    <div class="tab articles">
      <ul>
        <li each={result in or.data.results} data-id={result._id}>
          <img class="icon" src="/themes/dfk/images/Dokument-DOC.svg" />
          {parent.or.filters.l(result._source.title)}
        </li>
      </ul>
    </div>
    <div class="tab magazines">
      <ul>
        <li each={result in or.data.results} data-id={result._id}>
          <img class="icon" src="/themes/dfk/images/Dokument-DOC.svg" />
          {parent.or.filters.l(result._source.title)}
        </li>
      </ul>
    </div>
    <div class="tab interviews">
      <ul>
        <li each={result in or.data.results} data-id={result._id}>
          <img class="icon" src="/themes/dfk/images/Dokument-DOC.svg" />
          {parent.or.filters.l(result._source.title)}
        </li>
      </ul>
    </div>
    <div class="tab sources">
      <or-people-filter />
      <or-journals-filter />

      <div class="clearfix"></div>

      <or-list-item
        each={item in or.data.results}
        item={item}
      />
    </div>

    <or-modal />
  </div>

  <style type="text/scss">
    or-results {
      .controls a {
        cursor: pointer;
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

      or-people-filter, or-journals-filter {
        box-sizing: border-box;
        width: 50%;
        float: left;
      }

      .clearfix {
        clear: both;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      $(self.root).find('.tab').hide()
      $(self.root).find('.tab.sources').show()

      $(self.root).on 'click', '.controls a', (event) ->
        name = $(event.target).attr('name')
        $(self.root).find('.tab').hide()
        $(self.root).find(".tab.#{name}").show()
        self.or.bus.trigger 'type-select', name

      self.or.bus.on 'results', ->
        # console.log 'results', self.or.data
        self.update()

      self.or.bus.on 'type-aggregations', -> self.update()
  </script>
  
</or-results>