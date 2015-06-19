app.directive "orDocumentDialog", [
  "templates_service", "data_service", "session_service",
  (ts, ds, ss) ->
    directive = {
      scope: {
        "hash": "=orDocumentDialog"
      }
      template: ts.fetch "document-dialog"
      replace: "element"
    }
]