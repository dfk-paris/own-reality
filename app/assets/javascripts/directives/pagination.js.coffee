app.service "wuListing", [
  "$state", "wuBase64Location",
  (state, l) ->
    service = {
      build: (scope, name, options = {}) ->
        existing_params =  l.search()[name] || {}

        listing = {
          name: name
          filters: existing_params.filters || {}
          order: existing_params.order || []
          page: existing_params.page || 1
          per_page: existing_params.per_page || 10
          total: 0
          use_search: true
          next_page: -> service.next_page(listing)
          previous_page: -> service.previous_page(listing)
          on_first_page: -> service.on_first_page(listing)
          on_last_page: -> service.on_last_page(listing)
          total_pages: -> service.total_pages(listing)
          update_url: -> service.update_url(listing)
          query_params: -> service.query_params(listing)
        }
        
        angular.extend(listing, options)
        listing.filters = angular.extend({}, listing.default_filters, listing.filters)

        filters_changed = ->
          console.log "FILTERS CHANGED"
          listing.page = 1
          listing.update_url()
        page_changed = ->
          console.log "PAGE CHANGED"
          listing.update_url()
        url_search_changed = (nv, ov) ->
          console.log "URL_SEARCH_CHANGED", nv.filters, ov.filters
          listing.filters = l.search()[name].filters
          listing.page = l.search()[name].page
          listing.order = l.search()[name].order
          listing.per_page = l.search()[name].per_page
          listing.query()

        scope.$watch (-> listing.filters), filters_changed, true
        scope.$watch (-> listing.order), filters_changed, true
        scope.$watch (-> listing.per_page), filters_changed
        scope.$watch "#{name}.page", page_changed
        scope.$watch (-> l.search()[name]), url_search_changed, true

        listing
      next_page: (o) -> o.page += 1 unless service.on_last_page(o)
      previous_page: (o) -> o.page -= 1 unless service.on_first_page(o)
      on_first_page: (o) -> o.page == 1
      on_last_page: (o) -> o.page == service.total_pages(o)
      total_pages: (o) -> Math.ceil(o.total / o.per_page)
      query_params: (o) -> 
        return {
          filters: o.filters
          order: o.order
          page: o.page
          per_page: o.per_page
        }
      update_url: (o) -> 
        params = service.query_params(o)
        if o.use_search then l.search("#{o.name}": params) else o.query(params)
    }
]

app.directive "wuPagination", [
  "wuBase64Location",
  (l) ->
    directive = {
      scope: {
        page: "=wuPagination"
        total: "=wuTotal"
        per_page: "=wuPerPage"
        use_search: "=wuUseSearch"
      }
      link: (scope, element, attrs) ->
        scope.new_page ||= 1
        # scope.new_page = if scope.use_search
        #   console.log rp.page
        #   parseInt(rp.page) || 1
        # else
        #   1
        # scope.$on '$routeUpdate', -> scope.new_page = rp.page || 1
        scope.$watch "page", -> scope.update()

        scope.update = (new_page, event) ->
          event.preventDefault() if event

          if new_page
            scope.page = new_page

          if scope.page > scope.total_pages()
            scope.page = scope.total_pages()
          if scope.page < 1
            scope.page = 1

          # l.search(page: scope.page) if scope.use_search

        scope.total_pages = -> Math.ceil(scope.total / scope.per_page)

        # $(element).on "click", "input[type=number]", (event) -> $(event.target).select()

        scope.next = -> scope.update(scope.page + 1)
        scope.previous = -> scope.update(scope.page - 1)
        scope.is_first = -> scope.page == 1
        scope.is_last = -> scope.page == scope.total / scope.per_page

        $(element).on "click", ".next a", (event) ->
          event.preventDefault()
          scope.next()
          scope.$apply()
        $(element).on "click", ".previous a", (event) ->
          event.preventDefault()
          scope.previous()
          scope.$apply()

        window.l = l
        window.a = attrs
    } 
]