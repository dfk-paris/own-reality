app.service "wuListing", [
  "$state", "wuBase64Location",
  (state, l) ->
    service = {
      build: (scope, name, options = {}) ->
        from_url_params = ->
          ep =  l.search()[name] || {}
          listing.filters = ep.filters || options.default_filters || {}
          listing.page = ep.page || 1
          listing.order = ep.order || []
          listing.per_page = ep.per_page || 10

        listing = {
          name: name
          total: 0
          use_search: true
          query: options.query
        }
        
        service.extend(listing)
        from_url_params()

        filters_changed = (v, ov) ->
          console.log "FILTERS CHANGED", v
          listing.page = 1
          listing.update_url()
        page_changed = (v, ov) ->
          console.log "PAGE CHANGED"
          listing.update_url()
        url_search_changed = (v, ov) ->
          from_url_params()
          listing.query()

        scope.$watch (-> listing.filters), filters_changed, true
        scope.$watch (-> listing.order), filters_changed, true
        scope.$watch (-> listing.per_page), filters_changed
        scope.$watch (-> listing.page), page_changed
        scope.$watch (-> l.search()[name]), url_search_changed, true

        window.l = listing

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
        console.log("update URL")
        params = service.query_params(o)
        if o.use_search then l.search("#{o.name}": params) else o.query(params)
      extend: (o) ->
        o.next_page = -> service.next_page(o)
        o.previous_page = -> service.previous_page(o)
        o.on_first_page = -> service.on_first_page(o)
        o.on_last_page = -> service.on_last_page(o)
        o.total_pages = -> service.total_pages(o)
        o.update_url = -> service.update_url(o)
        o.query_params = -> service.query_params(o)
    }
]

app.directive "orPagination", [
  "wuBase64Location", "templates_service",
  (l, ts) ->
    directive = {
      scope: {
        listing: "=orPagination"
      }
      template: -> ts.fetch "or-pagination"
      replace: true
      link: (scope, element, attrs) ->
        scope.next = (event) -> 
          event.preventDefault()
          scope.listing.next_page()
        scope.previous = (event) ->
          event.preventDefault()
          scope.listing.previous_page()
    } 
]