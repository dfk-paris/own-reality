<or-source>
  <div>
    <h2>
      <or-localized-value value={opts.item._source.title} />
    </h2>

    <div class="or-metadata">
      <div class="or-field">
        <strong>{t('author', {count: 'other'})}:</strong>
        <or-person
          each={person in opts.item._source.people[12063]}
          person={person}
        />
      </div>
      <div class="or-field">
        <strong>{t('source', {count: 1})}:</strong>
        <or-journal-and-volume item={opts.item} />
      </div>
      <div class="or-field">
        <strong>{t('keyword', {count: 'other'})}:</strong>
        <or-attribute-list keys={opts.item._source.attrs.ids[6][43]} />
      </div>
    </div>

    <div class="or-text">
      <div class="or-field">
        <strong>{t('interpretation', {count: 1})}:</strong>
        <or-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="clearfix"></div>

    <div class="or-field">
      <strong>{t('recommended_citation_style', {count: 1})}:</strong>
      <or-citation item={opts.item} />
    </div>
  </div>

  <style type="text/scss">
    or-source, [riot-tag=or-source] {
      padding: 1rem;
      height: 500px;
      overflow: scroll;

      h2 {
        margin-bottom: 1.5rem;
      }

      .or-field {
        margin-bottom: 1rem;

        strong {
          display: block;
        }
      }

      .or-metadata {
        float: left;
        width: 30%;
      }

      .or-text {
        float: left;
        width: 70%;
        box-sizing: border-box;
        padding-left: 1rem;
      }

      .clearfix {
        clear: both;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or

    console.log 'mounting'
    self.on 'mount', ->
      self.or.cache_attributes(opts.item._source.attrs.ids[6][43])

    self.t = self.or.filters.t
  </script>
</or-source>