<or-citation>

  <virtual if={type() == 'sources'}>
    <virtual if={locale() == 'de'}>
      <or-people-list people={opts.item._source.people[12063]} />, 
      „{lcv(opts.item._source.title)}“, in 
      <or-journal-and-volume item={opts.item} />; siehe Resümee von 
      <or-user user={opts.item._source.created_by} />, auf der Projekt-Homepage 
      <em>OwnReality</em>, hg. von Mathilde Arnoux und Clément Layet, 2017, URL: 
      <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'fr'}>
      <or-people-list people={opts.item._source.people[12063]} />, « 
      {lcv(opts.item._source.title)} », dans 
      <or-journal-and-volume item={opts.item} /> ; voir la
      présentation en ligne par <or-user user={opts.item._source.created_by} />,
      sur le site du projet <em>OwnReality</em>, éd. par Mathilde Arnoux et 
      Clément Layet, 2017, URL : <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'en'}>
      <or-people-list people={opts.item._source.people[12063]} />, 
      “{lcv(opts.item._source.title)}”, in 
      <or-journal-and-volume item={opts.item} />; see summary by 
      <or-user user={opts.item._source.created_by} />, on the homepage of the 
      project <em>OwnReality</em>, ed. by Mathilde Arnoux and Clément Layet, 
      2017, URL: <a href={url()}>{url()}</a>.
    </virtual>
  </virtual>

  <virtual if={typeIsPaper()}>
    <virtual if={locale() == 'de'}>
      <or-people-list people={opts.item._source.people[16530]} />, 
      „{paperTitles()}“, auf der Projekt-Homepage 
      <em>OwnReality</em>, hg. von Mathilde Arnoux und Clément Layet, 2017, URL: 
      <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'fr'}>
      <or-people-list people={opts.item._source.people[16530]} />, « 
      {paperTitles()} », sur le site du projet 
      <em>OwnReality</em>, éd. par Mathilde Arnoux et Clément Layet, 2017, URL :
      <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'en'}>
      <or-people-list people={opts.item._source.people[16530]} />, 
      “{paperTitles()}”, on the homepage of the project 
      <em>OwnReality</em>, ed. by Mathilde Arnoux and Clément Layet, 2017, URL:
      <a href={url()}>{url()}</a>.
    </virtual>
  </virtual>

  <virtual if={type() == 'chronology'}>
    <virtual if={locale() == 'de'}>
      „{lcv(opts.item._source.title)}“, auf der Projekt-Homepage 
      <em>OwnReality</em>, hg. von Mathilde Arnoux und Clément Layet, 2017, URL:
      <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'fr'}>
      « {lcv(opts.item._source.title)} », sur le site du projet 
      <em>OwnReality</em>, éd. par Mathilde Arnoux et Clément Layet, 2017, URL :
      <a href={url()}>{url()}</a>.
    </virtual>

    <virtual if={locale() == 'en'}>
      “{lcv(opts.item._source.title)}”, on the homepage of the project 
      <em>OwnReality</em>, ed. by Mathilde Arnoux and Clément Layet, 2017, URL:
      <a href={url()}>{url()}</a>.
    </virtual>
  </virtual>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.type = -> tag.opts.item._type
    tag.typeIsPaper = ->
      tag.opts.item._type == 'articles' ||
      tag.opts.item._type == 'magazines' ||
      tag.opts.item._type == 'interviews'

    tag.paperTitles = ->
      order = switch
        when 'en' then ['en', 'de', 'fr']
        when 'de' then ['de', 'fr', 'en']
        when 'fr' then ['fr', 'de', 'en']

      titles = (tag.opts.item._source.title[l] for l in order when !!tag.opts.item._source.title[l])
      titles.join('/')

    tag.url = -> 
      base = document.location.href.split('#')[0]
      "#{base}#/resolve/#{tag.opts.item._type}/#{tag.opts.item._id}/#{tag.locale()}/#{tag.contentLocale()}"

    tag.date = ->
      ts = tag.opts.item._source.updated_at
      tag.l(ts)


  </script>
</or-citation>