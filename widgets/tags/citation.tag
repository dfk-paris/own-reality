<or-citation>

  <div if={locale() == 'de'}>
    <or-people-list people={opts.item._source.people[12063]} />,
    „{opts.item._source.title.de}“, in
    <or-journal-and-volume item={opts.item} />;
    siehe Resümee von <or-user user={opts.item._source.created_by} />,
    online seit {date()}, URL: <a href={url()}>{url()}</a>.
  </div>

  <div if={locale() == 'fr'}>
    <or-people-list people={opts.item._source.people[12063]} />,
    « {opts.item._source.title.fr} », dans
    <or-journal-and-volume item={opts.item} />;
    voir la présentation en ligne de <or-user user={opts.item._source.created_by} />,
    mise en ligne le {date()}, URL: <a href={url()}>{url()}</a>.
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.url = -> 
      base = document.location.href.split('#')[0]
      "#{base}#/resolve/#{tag.opts.item._type}/#{tag.opts.item._id}/#{tag.locale()}/#{tag.contentLocale()}"
    tag.date = ->
      ts = tag.opts.item._source.updated_at
      tag.l(ts)
  </script>
</or-citation>