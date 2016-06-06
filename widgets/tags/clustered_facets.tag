<or-clustered-facets>
  
  <div>
    <div class="or-selected">
      <span data-id={role_id} class="role" each={role_id, people in keys.people}>
        <span class="item" each={key in people}>
          {parent.or.i18n.l(parent.or.config.server.roles[role_id])}:
          <or-person person-id={key} />
        </span>
      </span>
      <span class="item" each={key in keys.journals} data-id={key}>
        {or.filters.limitTo(key)}
      </span>
      <span class="item" each={key in keys.attribs}>
        <or-attribute key={key} />
      </span>
    </div>

    <div class="or-buckets">
      <div
        class="or-bucket"
        each={key, aggregation in opts.aggregations.people}
        data-id={key}
        if={aggregation.buckets.length > 0}
      >
        <a
          href={parent.opts.orBaseTargetPeopleUrl}
          class="or-show-all"
          show={parent.many_buckets(aggregation)}
          data-type="people"
        >
          {parent.or.i18n.t('show_all')}
          <span show={parent.countless_buckets(aggregation)}>(> 20)</span>
        </a>
        <div class="or-role">
          {parent.or.i18n.l(parent.or.config.server.roles[key])}
        </div>
        <div class="or-value" each={bucket in limit_buckets(key, aggregation)}>
          •
          <a class="or-select"><or-person person-id={bucket.key} /></a>
          ({bucket.doc_count})
        </div>
      </div>

      <div
        class="or-bucket"
        if={opts.aggregations.journals.buckets.length > 0}
      >
        <a
          href="#"
          class="or-show-all"
          show={parent.many_buckets(opts.aggregations.journals)}
          data-type="journals"
        >
          {parent.or.i18n.t('show_all')}
          <span show={parent.countless_buckets(aggregation)}>(> 20)</span>
        </a>
        <div class="or-custom-category">
          {parent.or.i18n.t('magazine', {count: 'other'})}
        </div>
        <div class="or-value" each={bucket in limit_buckets('journals', opts.aggregations.journals)}>
          •
          <a class="or-select">{bucket.key}</a>
          ({bucket.doc_count})
        </div>
      </div>

      <div
        class="or-bucket"
        each={key, aggregation in opts.aggregations.attribs}
        if={aggregation.buckets.length > 0}
        data-id={key}
      >
        <a
          href={parent.attribs_url(key)}
          class="or-show-all"
          show={parent.many_buckets(aggregation)}
          data-type="attribs"
        >
          {parent.or.i18n.t('show_all')}
          <span show={parent.countless_buckets(aggregation)}>(> 20)</span>
        </a>
        <div class="or-category">
          {parent.or.i18n.l(parent.or.config.server.categories[key])}
        </div>
        <div class="or-value" each={bucket in limit_buckets(key, aggregation)}>
          •
          <a class="or-select"><or-attribute key={bucket.key} /></a>
          ({bucket.doc_count})
        </div>
      </div>
    </div>
  </div>

  <style type="text/scss">
    or-clustered-facets {
      a {
        cursor: pointer;
      }

      a.or-show-all {
        font-size: 0.7rem;
      }

      .item {
        cursor: pointer;
        font-size: 0.7rem;
        border-radius: 3px;
        padding: 0.2rem;
        background-color: darken(#ffffff, 20%);
        white-space: nowrap;
        display: inline-block;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
      }

      .or-bucket {
        margin-top: 1rem;

        .or-show-all {
          display: block;
          float: right;
        }

        .or-category, .or-role {
          margin-bottom: 0.1rem;
        }
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.keys = {
      attribs: []
      people: {}
      journals: []
    }
    self.expanded = {}

    self.or.bus.on 'packed-data', (data) ->
      self.keys.attribs = data['attribs'] || []
      self.keys.people = data['people'] || {}
      self.keys.journals = data['journals'] || []
      for attrib_id in self.keys.attribs
        self.or.cache_attributes [attrib_id]
      for role_id, people of self.keys.people
        for person_id in people
          self.or.cache_people [person_id]
      self.notify()


    self.add = (what = {}, notify = true) ->
      what['attribs'] ||= []
      what['people'] ||= {}
      what['journals'] ||= []

      unpacked = ownreality.routing.unpack()
      for item in what.attribs
        unpacked.attribs ||= []
        unpacked.attribs.push(item)
      for role, people of what.people
        for person in people
          unpacked['people'] ||= {}
          unpacked.people[role] ||= []
          unpacked.people[role].push(person)
      for item in what.journals
        unpacked.journals ||= []
        unpacked.journals.push(item)
      ownreality.routing.pack(unpacked)

    self.remove = (what = {}, notify = true) ->
      what['attribs'] ||= []
      what['people'] ||= {}
      what['journals'] ||= []

      unpacked = ownreality.routing.unpack()
      for item in what.attribs
        i = unpacked.attribs.indexOf(item)
        unpacked.attribs.splice(i, 1)
      for role_id, people of what.people
        role_id = parseInt(role_id)
        for person in people
          i = unpacked.people[role_id].indexOf(person)
          unpacked.people[role_id].splice(i, 1)
        delete unpacked.people[role_id] if unpacked.people[role_id].length == 0
        delete unpacked['people'] if JSON.stringify(unpacked['people']) == '{}'
      for item in what.journals
        i = unpacked.journals.indexOf(item)
        unpacked.journals.splice(i, 1)
      console.log 'remove:', unpacked
      ownreality.routing.pack(unpacked)

    self.reset = (what = {}, notify = true) ->
      ownreality.routing.set_packed(
        attribs: []
        people: {}
        journals: []
      )

    self.on 'mount', ->

      $(self.root).on 'click', '.or-bucket a.or-select', (event) ->
        event.preventDefault()
        if key = $(event.target).parents('or-attribute').attr('key')
          self.add attribs: [key]
        else if key = $(event.target).parents('or-person').attr('person-id')
          role_id = $(event.target).parents('.or-bucket').attr('data-id')
          what = {people: {}}
          what.people[role_id] = [key]
          self.add what
        else
          key = $(event.target).text()
          self.add journals: [key]

      $(self.root).on 'click', '.or-selected .item', (event) ->
        event.preventDefault()
        if key = $(event.target).parents('or-attribute').attr('key')
          self.remove attribs: [key]
        else if key = $(event.target).parents('or-person').attr('person-id')
          role_id = $(event.target).parents('.role').attr('data-id')
          what = {people: {}}
          what.people[role_id] = [key]
          self.remove what
        else
          key = $(event.target).attr('data-id')
          self.remove journals: [key]

      $(self.root).on 'click', '.or-show-all', (event) ->
        event.preventDefault()
        key = $(event.target).parents('.or-bucket').attr('data-id')
        type = $(event.target).attr('data-type')
        agg = self.opts.aggregations[type]
        agg = agg[parseInt(key)] if key
        if self.many_buckets(agg) 
          if self.countless_buckets(agg)
            document.location.href = $(event.target).attr('href')
            # console.log 'dialog', agg.buckets.length
          else
            self.expanded[key] = !self.expanded[key]
            self.update()
        
    self.notify = ->
      if self.parent
        self.parent.trigger('or-change', self)
      self.update()

    self.limit_buckets = (key, agg) ->
      if self.expanded[key] then agg.buckets else agg.buckets.slice(0, 5)
    self.many_buckets = (agg) -> agg.buckets.length > 5
    self.countless_buckets = (agg) -> agg.buckets.length > 20
    self.attribs_url = (key) ->
      pack = self.or.routing.pack_to_string(category_id: key)
      "#{self.opts.orBaseTargetAttribsUrl}#/?q=#{pack}"

    self.value = -> self.keys

  </script>
</or-clustered-facets>