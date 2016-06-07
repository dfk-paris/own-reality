<or-citation>
  <div class="citation">
    <div if={or.config.locale == 'de'}>
      <or-people-list people={opts.item._source.people[12063]} />,
      „{opts.item._source.title.de}“, in
      <or-journal-and-volume item={opts.item} />;
      siehe Resümee von <or-user user={opts.item._source.created_by} />,
      online seit {date()}, URL: <a href={url()}>{url()}</a>.
    </div>
    <div if={or.config.locale == 'fr'}>
      <or-people-list people={opts.item._source.people[12063]} />,
      « {opts.item._source.title.fr} », dans
      <or-journal-and-volume item={opts.item} />;
      voir la présentation en ligne de <or-user user={opts.item._source.created_by} />,
      mise en ligne le {date()}, URL: <a href={url()}>{url()}</a>.
    </div>
  </div>

  <script type="text/coffee">
    self = this
    

    self.url = -> 
      base = document.location.href.split('#')[0]
      hash = self.or.routing.pack_to_string(
        modal: true
        tag: 'or-source'
        id: self.opts.item._id
        clang: self.or.config.clang
      )
      "#{base}#?q=#{hash}"
    self.date = ->
      ts = self.opts.item._source.updated_at
      self.or.i18n.ld(ts)
  </script>
</or-citation>