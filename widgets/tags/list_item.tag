<or-list-item>

  <div>
    <div if={opts.item._type == 'sources'}>
      <or-medium item={opts.item} />
      <or-people-list people={opts.item._source.people[12063]} />
      <a class="or-modal-trigger" or-tag="or-source">
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </a>
      <or-journal-and-volume item={opts.item} />
      <or-localized-value
        class="or-text"
        value={opts.item._source.interpretation}
      />
    </div>

    <div if={opts.item._type == 'interviews'}>
      <or-medium item={opts.item} />
      <or-people-list people={opts.item._source.people[16530]} />
      <a class="or-modal-trigger" or-tag="or-interview">
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </a>
    </div>

    <div if={opts.item._type == 'articles'}>
      <or-medium item={opts.item} />
      <or-people-list people={opts.item._source.people[16530]} />
      <a class="or-modal-trigger" or-tag="or-article">
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </a>
    </div>

    <div if={opts.item._type == 'magazines'}>
      <or-medium item={opts.item} />
      <or-people-list people={opts.item._source.people[16530]} />
      <a class="or-modal-trigger" or-tag="or-magazine">
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </a>
    </div>

    <div if={opts.item._type == 'chronology'}>
      <or-people-list people={opts.item._source.people[12064]} />
      <a class="or-modal-trigger-inactive" or-tag="or-chronology">
        <or-localized-value class="or-title" value={opts.item._source.title} />
      </a>
      <i>{range_label()}</i>
    </div>

    <div class="clearfix"></div>
  </div>

  <style type="text/scss">
    or-list-item {
      display: block;
      border-top: 1px solid black;
      border-bottom: 1px solid black;
      margin-bottom: -1px;
      padding: 1em;
      padding-top: 2em;
      padding-bottom: 2em;

      a {
        cursor: pointer;
      }

      &:first-child {
        border-top: 0px;
      }

      &:last-child {
        border-bottom: 0px;
      }

      or-medium {
        float: right;
        margin-left: 1em;
      }

      or-person {
        display: block;
        font-size: 0.8rem;
        line-height: 1rem;
        color: grey;
        margin-bottom: 0.3rem;
      }

      .or-title {
        display: block;
      }

      or-journal-and-volume {
        display: block;
        font-size: 0.8rem;
        line-height: 1rem;
        color: grey;
        margin-bottom: 0.7em;
      }

      .or-text {
        display: block;
        font-size: 0.8rem;
        line-height: 1rem;
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
      $(self.root).on 'click', 'a.or-modal-trigger', (event) ->
        event.preventDefault()
        tag = $(event.currentTarget).attr('or-tag')
        self.or.route.query modal: 'true', tag: tag, id: self.opts.item._id

    self.range_label = ->
      from = self.ld(self.opts.item._source.from_date)
      to = self.ld(self.opts.item._source.to_date)
      if from == to
        from
      else
        "#{from} – #{to}"

    self.ld = self.or.filters.ld
  </script>

</or-list-item>