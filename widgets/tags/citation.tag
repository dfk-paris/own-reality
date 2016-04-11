<or-citation>
  <div class="citation">
    <div if={or.config.locale == 'de'}>
      <or-people-list people={opts.item._source.people[12063]} />,
      „{opts.item._source.title.de}“, in
      <or-journal-and-volume item={opts.item} />;
      siehe Resümee von <or-user user={opts.item._source.updated_by}>,
      online seit 12.9.2015, URL: {url()}.
    </div>
    <div if={or.config.locale == 'fr'}>
      <or-people-list people={opts.item._source.people[12063]} />,
      « {opts.item._source.title.fr} », dans
      <or-journal-and-volume item={opts.item} />;
      voir la présentation en ligne de <or-user user={opts.item._source.updated_by}>,
      mise en ligne le 12.9.2015, URL: {url()}.
    </div>
  </div>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.url = -> "https://google.com"
  </script>
</or-citation>