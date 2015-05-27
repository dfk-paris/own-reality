app.service "templates_service", [
  ->
    service = {
      fetch: (id) -> $("script[type='text/x-ng-tpl'][data-id='#{id}']").html()
    }
]