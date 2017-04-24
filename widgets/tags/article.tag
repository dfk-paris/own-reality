<or-article>
  
  <div class="header">
    <div class="formats">
      <a href="#"><or-icon which="doc" /></a>
      <a href="#"><or-icon which="print" /></a>

      <div class="language-selector">
        <a href="#">deutsch</a>
        <a href="#">französisch</a>
        <a href="#">englisch</a>
        <a href="#">polnisch</a>
      </div>
    </div>
    <div class="navigation">
      <a href="#">{t('article')}</a>
      <a href="#">{t('people_involved')}</a>
      <a href="#">{t('keyword', {count: 'other'})}</a>
      <a href="#">{t('recommended_citation_style')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <virtual if={opts.item}>
    <or-paper if={opts.item._type == 'articles'} item={opts.item} />
  </virtual>

  <!-- <or-item-metadata item={opts.item} /> -->

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      if tag.opts.item
        tag.cache.attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{wApp.config.api_url}/api/items/articles/#{tag.opts.id}"
          success: (data) ->
            console.log data
            tag.opts.item = data.docs[0]
            tag.cache_attributes()
            tag.update()
        )

    tag.cache_attributes = ->
      try
        wApp.cache.attributes(tag.opts.item._source.attrs.ids[6][43])
      catch e
        console.log e
  </script>
  
</or-article>