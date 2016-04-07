<or-results>
  
  <div class="result-tabs">
    <div class="controls">
      <a name="articles">{or.filters.t('article', {count: 'other'})}</a>
      <a name="magazines">{or.filters.t('magazine', {count: 'other'})}</a>
      <a name="interviews">{or.filters.t('interview', {count: 'other'})}</a>
      <a name="sources">{or.filters.t('source', {count: 'other'})}</a>
    </div>
    <div class="tab articles">
      articles
    </div>
    <div class="tab magazines">
      magazines
    </div>
    <div class="tab interviews">
      interviews
    </div>
    <div class="tab sources">
      <ul>
        <li each={result in or.data.results}>
          {parent.or.filters.l(result._source.title)}
        </li>
      </ul>
    </div>
  </div>

  <style type="text/scss">
    or-results .controls a {
      cursor: pointer;
    }

    or-results ul li:before {
      content: none !important;
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
        console.log name
        $(self.root).find('.tab').hide()
        $(self.root).find(".tab.#{name}").show()

      self.or.bus.on 'results', ->
        console.log 'results', self.or.data
        self.update()
  </script>
  
</or-results>