app.directive "article", [
  ->
    el = null

    directive = {
      restrict: "C"
      link: (scope, element) ->
        $('body').on "click", (event) ->
          console.log "remove"
          if el
            el.popover("destroy")
            el = null

        element.on "click", "a.footnotecall", (event) ->
          console.log "add"
          event.preventDefault()

          unless el
            event.stopPropagation()

            el = $(event.currentTarget)
            id = el.attr("id").replace(/^body/, '')
            num = id.replace(/^ftn/, '')
            text = $("a##{id}").parent().text()
            el.popover(
              title: "Footnote #{num}"
              content: text
              container: 'body'
              trigger: "manual"
            )
            el.popover("show")
    }
]