<or-clustered-facets>
  
  <div>
    <div class="or-selected">
      <span data-id={role_id} class="role" each={role_id, people in keys.people}>
        <span class="item" each={key in people}>
          <or-person person-id={key} />
        </span>
      </span>
      <span class="item" each={key in keys.journals} data-id={key}>
        {or.filters.limitTo(key)}
      </span>
      <span class="item" each={key in keys.attrs}>
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
          href="#"
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
        each={key, aggregation in opts.aggregations.attrs}
        if={aggregation.buckets.length > 0}
        data-id={key}
      >
        <a
          href="#"
          class="or-show-all"
          show={parent.many_buckets(aggregation)}
          data-type="attrs"
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
    window.cf = self
    
    self.keys = {
      attrs: []
      people: {}
      journals: []
    }
    self.expanded = {}

    self.add = (what = {}, notify = true) ->
      what['attrs'] ||= []
      what['people'] ||= {}
      what['journals'] ||= []

      for item in what.attrs
        if self.keys.attrs.indexOf(item) == -1
          self.keys.attrs.push(item)
          self.notify() if notify

      for role, people of what.people
        for person in people
          self.keys.people[role] ||= []
          if self.keys.people[role].indexOf(person) == -1
            self.keys.people[role].push(person)
            self.notify() if notify

      for item in what.journals
        if self.keys.journals.indexOf(item) == -1
          self.keys.journals.push(item)
          self.notify() if notify

      self.update()

    self.remove = (what = {}, notify = true) ->
      what['attrs'] ||= []
      what['people'] ||= {}
      what['journals'] ||= []

      for item in what.attrs
        i = self.keys.attrs.indexOf(item)
        if i != -1
          self.keys.attrs.splice(i, 1)
          self.notify() if notify
      for role, people of what.people
        for person in people
          i = self.keys.people[role].indexOf(person)
          if person != -1
            self.keys.people[role].splice(i, 1)
            self.notify() if notify

      for item in what.journals
        i = self.keys.journals.indexOf(item)
        if i != -1
          self.keys.journals.splice(i, 1)
          self.notify() if notify

      self.update()

    self.reset = (what = {}, notify = true) ->
      self.keys = {
        attrs: []
        people: {}
        journals: []
      }
      self.notify() if notify
      self.update()

    self.on 'mount', ->

      $(self.root).on 'click', '.or-bucket a.or-select', (event) ->
        event.preventDefault()
        if key = $(event.target).parents('or-attribute').attr('key')
          self.add attrs: [key]
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
          self.remove attrs: [key]
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
        agg = agg[key] if key
        if self.many_buckets(agg) 
          if self.countless_buckets(agg)
            console.log 'dialog', agg.buckets.length
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

    self.value = -> self.keys

  </script>
</or-clustered-facets>