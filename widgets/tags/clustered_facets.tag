<or-clustered-facets>

  <div if={opts.aggregations}>
    
    <div
      if={hasSelection()}
      class="or-selected or-badge-list"
    >
      <div class="or-search-header">{tcap('your_selection')}</div>
      <virtual each={people, role_id in keys.people}>
        <span
          class="or-item-wrapper"
          each={key in people}
          onclick={remove('people', role_id, key)}
        >
          <span class="or-item">
            ×
            {lvcap(wApp.config.server.plural_roles[role_id])}:
            <or-person person-id={key} />
          </span>
        </span>
      </virtual>
      <span
        class="or-item-wrapper"
        each={key in keys.journals} data-id={key}
        onclick={remove('journals', null, key)}
      >
        <span class="or-item">× {wApp.utils.shorten(key)}</span>
      </span>
      <span
        class="or-item-wrapper"
        each={key in keys.attribs}
        onclick={remove('attribs', null, key)}
      >
        <span class="or-item">
          ×
          <or-attribute key={key} />
        </span>
      </span>
    </div>

    <div class="or-buckets">
      <div class="or-search-header">{tcap('keyword', {count: 'other'})}</div>

      <!-- people bucket -->
      <div
        class="or-bucket or-badge-list"
        each={aggregation, key in opts.aggregations.people}
        data-id={key}
      >
        <virtual if={aggregation.buckets.length > 0}>
          <div class="or-role">
            {lvcap(wApp.config.server.plural_roles[key])}
          </div>
          <a
            href={opts.orBaseTargetPeopleUrl}
            class="or-show-all"
            onclick={showAll('people', aggregation, key)}
            show={many_buckets(aggregation)}
          >
            <span class="w-nowrap">
              {t('show_all')}
            </span>
          </a>

          <div class="w-clearfix"></div>

          <div class="or-item-wrapper" each={bucket in limit_buckets(key, aggregation)}>
            <span class="or-value or-item or-select" >
              +
              <or-person person-id={bucket.key} />
              ({bucket.doc_count})
            </span>
          </div>
        </virtual>
      </div>

      <!-- journal bucket -->
      <div
        class="or-bucket or-badge-list"
        if={opts.aggregations.journals.buckets.length > 0}
      >
        <div class="or-custom-category">
          {tcap('magazine', {count: 'other'})}
        </div>
        <a
          href="#"
          class="or-show-all"
          show={many_buckets(opts.aggregations.journals)}
          onclick={showAll('journals', opts.aggregations.journals)}
        >
          <span class="w-nowrap">
            {t('show_all')}
          </span>
        </a>

        <div class="w-clearfix"></div>

        <div class="or-item-wrapper" each={bucket in limit_buckets('journals', opts.aggregations.journals)}>
          <span class="or-value or-item or-select">
            +
            <span class="or-key">{bucket.key}</span>
            ({bucket.doc_count})
          </span>
        </div>
      </div>

      <!-- keyword buckets -->
      <div
        class="or-bucket or-badge-list"
        each={aggregation, key in opts.aggregations.attribs}
        if={aggregation.buckets.length > 0}
        data-id={key}
      >
        <div class="or-category">
          {lv(wApp.config.server.categories[key])}
        </div>
        <a
          href={attribs_url(key)}
          class="or-show-all"
          onclick={showAll('attribs', aggregation, key)}
          show={many_buckets(aggregation)}
          key={key}
        >
          <span class="w-nowrap">
            {t('show_all')}
          </span>
        </a>

        <div class="w-clearfix"></div>

        <div class="or-item-wrapper" each={bucket in limit_buckets(key, aggregation)}>
          <span class="or-value or-item or-select">
            +
            <or-attribute key={bucket.key} />
            ({bucket.doc_count})
          </span>
        </div>
      </div>
    </div>
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.keys = {
      attribs: []
      people: {}
      journals: []
    }
    tag.expanded = {}

    tag.on 'mount', ->
      wApp.bus.on 'routing:query', tag.url_handler

    tag.on 'unmount', ->
      wApp.bus.off 'routing:query', tag.url_handler

    tag.url_handler = ->
      data = wApp.routing.packed()
      tag.keys.attribs = data['attribs'] || []
      tag.keys.people = data['people'] || {}
      tag.keys.journals = data['journals'] || []
      for attrib_id in tag.keys.attribs
        wApp.cache.attributes [attrib_id]
      for role_id, people of tag.keys.people
        for person_id in people
          wApp.cache.people [person_id]
      tag.notify()

    tag.add = (what = {}, notify = true) ->
      what['attribs'] ||= []
      what['people'] ||= {}
      what['journals'] ||= []

      unpacked = wApp.routing.packed()
      unpacked.page = 1
      for item in what.attribs
        unpacked.attribs ||= []
        unpacked.attribs.push(item)
      for role, people of what.people
        for person in people
          unpacked['people'] ||= {}
          unpacked.people[role] ||= []
          unpacked.people[role].push(parseInt(person))
      for item in what.journals
        unpacked.journals ||= []
        unpacked.journals.push(item)
      wApp.routing.packed(unpacked)

    tag.remove = (type, role_id, key) ->
      (event) ->
        event.preventDefault()

        newPacked = wApp.routing.packed()
        newPacked.page = 1

        switch type
          when 'people'
            role_id = parseInt(role_id)
            i = newPacked.people[role_id].indexOf(key)
            newPacked.people[role_id].splice(i, 1)
            delete newPacked.people[role_id] if newPacked.people[role_id].length == 0
            newPacked.people = null if JSON.stringify(newPacked['people']) == '{}'
          when 'journals'
            i = newPacked.journals.indexOf(key)
            newPacked.journals.splice(i, 1)
            newPacked.journals = null if newPacked.journals.length == 0
          when 'attribs'
            i = newPacked.attribs.indexOf(key)
            newPacked.attribs.splice(i, 1)
            newPacked.attribs = null if newPacked.attribs.length == 0

        wApp.routing.packed(newPacked)

    tag.reset = (what = {}, notify = true) ->
      wApp.routing.packed(
        page: 1
        attribs: []
        people: {}
        journals: []
      )

    tag.on 'mount', ->
      tag.bus = riot.observable()

      tag.bus.on 'person-clicked', (role_id, id) ->
        what = {people: {}}
        what.people[role_id] = [id]
        tag.add what

      tag.bus.on 'attrib-clicked', (id) ->
        tag.add attribs: [id]

      Zepto(tag.root).on 'click', '.or-bucket .or-select', (event) ->
        event.preventDefault()
        if key = Zepto(event.target).parents('or-attribute').attr('key')
          tag.add attribs: [key]
        else if key = Zepto(event.target).parents('or-person').attr('person-id')
          role_id = Zepto(event.target).parents('.or-bucket').attr('data-id')
          what = {people: {}}
          what.people[role_id] = [key]
          tag.add what
        else
          key = Zepto(event.target).select('.or-key').text()
          tag.add journals: [key]

    tag.showAll = (type, agg, key) ->
      (event) ->
        event.preventDefault()
        if tag.many_buckets(agg) 
          if tag.countless_buckets(agg)
            wApp.bus.trigger('modal', 'or-attribute-selector',
              orType: type
              orCategoryId: key
              bus: tag.bus
            )
            # document.location.href = $(event.target).attr('href')
            # console.log 'dialog', agg.buckets.length
          else
            tag.expanded[key || type] = !tag.expanded[key || type]
            tag.update()
        
    tag.notify = ->
      if tag.parent
        tag.parent.trigger('or-change', tag)
      tag.update()

    tag.limit_buckets = (key, agg) ->
      if tag.expanded[key] then agg.buckets else agg.buckets.slice(0, 5)
    tag.many_buckets = (agg) -> agg.buckets.length > 5
    tag.countless_buckets = (agg) -> agg.buckets.length > 20
    tag.attribs_url = (key) ->
      pack = wApp.routing.pack(category_id: key)
      "#{tag.opts.orBaseTargetAttribsUrl}#/?q=#{pack}"

    tag.value = -> tag.keys

    tag.hasSelection = ->
      !Zepto.isEmptyObject(tag.keys.people) ||
      tag.keys.attribs.length > 0 ||
      tag.keys.journals.length > 0

  </script>

</or-clustered-facets>