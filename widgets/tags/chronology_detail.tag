<or-chronology-detail>
  
  <div class="chronology-detail">
    <h2>
      <or-localized-value value={opts.item._source.title} />
    </h2>

    <div class="or-metadata">
      <div class="or-field" each={role_id, people in opts.item._source.people} >
        <strong>
          {parent.or.filters.l(parent.or.config.server.roles[role_id])}:
        </strong>
        <or-people-list people={people} />
      </div>
    </div>

    <div class="or-text">
      <div class="or-field">
        <or-localized-value value={opts.item._source.interpretation} />
      </div>
    </div>

    <div class="clearfix"></div>
    
    <div class="or-field">
      <strong>{t('keyword', {count: 'other'})}:</strong>
      <or-attribute-list keys={opts.item._source.attrs.ids[6][43]} />
    </div>
  </div>

  <style type="text/scss">
    or-chronology-detail, [riot-tag=or-chronology-detail] {
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

    self.on 'mount', ->
      self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])

    self.t = self.or.filters.t
  </script>

</or-chronology-detail>